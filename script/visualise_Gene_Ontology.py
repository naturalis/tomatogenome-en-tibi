

# https://github.com/naturalis/brassica-snps/blob/master/script/go_treebuilder.pl
# https://pypi.org/project/pronto/#-examples
# https://pronto.readthedocs.io/en/latest/examples/ms.html#Loading-ms.obo
# https://pypi.org/project/obonet/#description

import networkx
import obonet
import textwrap


GO_file = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/snpEff/go-basic.obo"
Annotated_IDs = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/snpEff/annotated.transcript.ids.TS153.unique.txt"
output = "C:/Users/HP 8460p/Documents/Biology master/En tibi internship/Data/snpEff/Individual_GO_Graph_TS_153.txt"

# Read in Gene Ontology using obonet
GO = obonet.read_obo(GO_file)
print('Amount of GO terms in total:',len(GO))
print('networkx.is_directed_acyclic_graph =', networkx.is_directed_acyclic_graph(GO))

# Create empty graph to store all relevant GO terms.
Individual_GO_graph = networkx.MultiGraph()

# Create empty dict to store genes associated with specific GO terms
associated_genes = {}
edges = []
# Loop over every line (gene) in the file, and extract the GO terms associated with each gene.
with open(Annotated_IDs) as f_in:
    Genes = f_in.readlines()
    for line in Genes:
        Gene = line.split('\t')
        gene_GO_terms = Gene[1].split(' ')      # GO  terms are separated by a space
        Gene = Gene[0]                          # Store gene ID to be able to print on final graph

        # Loop over every GO term for each gene, Find tree
        for item in gene_GO_terms:
            item = item.rstrip()                # Remove any possible trailing whitespace

            # Find all simple paths from 'biological_process' to node
            paths = networkx.all_simple_paths(GO, item, 'GO:0008150')
            for path in map(networkx.utils.pairwise, paths): # Look at the edges in every path
                for edge in path:
                    if edge not in edges:
                        edges.append(edge)


            #subtree = networkx.dfs_edges(GO, item)  # Depth first search to find all parents of the node
            #Individual_GO_graph.add_edges_from(subtree)     # Add all edges (and nodes) to the GO graph of the individual.

            # Store the associated genes for each GO term mentioned in the input file.
            # Store as list in dictionary to allow for multiple genes for each term.

            if item not in associated_genes:
                associated_genes[item] = [Gene]
            else:associated_genes[item].append(Gene)
Individual_GO_graph = networkx.MultiDiGraph()
Individual_GO_graph.add_edges_from(edges)
Individual_GO_graph = Individual_GO_graph.reverse()     # To ensure proper direction of the edges

print("networkx.is_directed_acyclyic_graph =", networkx.is_directed_acyclic_graph(Individual_GO_graph))
for node in Individual_GO_graph:
    if GO.nodes[node]['namespace'] != 'biological_process':  # Only look at terms in the category 'biological process'
        networkx.Graph.remove_node(node)
        del associated_genes[node]


#print('Amount of terms in individual GO graph:', Individual_GO_graph.number_of_nodes())
#print('Amount of edges in individual GO graph:', Individual_GO_graph.number_of_edges())
# create attribute 'label' to be able to display the name in doteditor.
attributes = {}
# Loop over GO terms in the individual graph, and add data to label from the original graph
for node in Individual_GO_graph.nodes:
    name = GO.nodes[node]['name']
    # Add text wrapping to ensure that the name can be properly displayed on the graph.
    name = textwrap.wrap(name, width=29, break_long_words = False)
    name = '\n'.join(name)
    text = '\n'.join([node,name])
    URL = 'http://amigo.geneontology.org/amigo/term/' + node
    if node in associated_genes:
        n_genes = len(associated_genes[node])
        text = '\n'.join([text,str(n_genes)])
    # Networkx requires dict of dict style to properly add information to the graph
    attributes[node] = {'label': text, 'URL': URL}
networkx.set_node_attributes(Individual_GO_graph, attributes)

new_name = {}
for node in Individual_GO_graph.nodes:
    new_name[node] = str(node).replace(':', '_')
    #print(new_name[node])
Individual_GO_graph = networkx.relabel_nodes(Individual_GO_graph,new_name)

#print(Individual_GO_graph.nodes['GO:0022610'])

networkx.nx_pydot.write_dot(Individual_GO_graph, output)
Individual_GO_graph = networkx.nx_pydot.to_pydot(Individual_GO_graph)




