for i in 1	11	22	33	35	36	37	38	39	161	2	3	4	17	18	19	20	21	23	24	25	26	27	28	29	30	31	32	34	70	81	92	103	106	107	108	109	110	112	113	114	115	116	117	118	119	120	121	122	123	124	125	126	127	128	129	130	131	132	133	135	136	137	139	141	142	143	144	145	146	147	148	149	150	151	152	154	155	156	157	158	159	160	162	163	164	165	166	167	168	169	170	171	172	173	174	175	176	177	178	179	180	181	182	183	184	187	188	189	190	191	192	193	194	195	196	197	198	199	200	201	202	203	204	205	209	210	211	212	213	214	215	216	217	219	220	221	222	223	224	225	227	228	229	230	231	232	233	234	235	236	237	238	239	240	241	242	243	245	247	248	249	250	251	252	253	254	255	256	257	258	259	260	262	263	264	265	266	267	268	271	272	273	274	275	276	277	280	281	282	283	285	286	287	288	289	290	291	292	293	294	295	296	297	298	299	300	301	302	303	304	305	307	308	309	310	311	312	313	314	315	316	317	318	319	320	321	322	323	324	325	326	330	331	332	333	334	335	336	337	338	339	340	341	342	343	344	345	346	347	348	349	350	351	353	354	355	356	357	358	359	360	40	41	42	43	44	45	46	47	48	49	50	51	52	53	54	55	56	57	58	59	60	61	62	63	69	85	88	89	90	93	94	99 	
do	 
	for j in 01 02 03 04 05 06 07 08 09 10 11 12  
	do
		./introgression_same_diff_TS-403.py  -input Chr$j.final.genotype_cp_and_refrence.genotype -num $i -output line-$i-Chr$j.same_diff_TS-403 
		./count_window_tomato-same_difference.py  -input line-$i-Chr$j.same_diff_TS-403  -output line-$i-Chr$j-rato_100k_TS-403.xls -Chr $j
		rm line-$i-Chr$j.same_diff_TS-403 
	done
		cat line-$i-Chr*-rato_100k_TS-403.xls > line-$i-rato_100k_TS-403.xls
		rm line-$i-Chr*-rato_100k_TS-403.xls
done 