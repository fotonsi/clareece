--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: permisos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: entrada
--

SELECT pg_catalog.setval('permisos_id_seq', 393, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: entrada
--

SELECT pg_catalog.setval('roles_id_seq', 6, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: entrada
--

SELECT pg_catalog.setval('usuarios_id_seq', 15, true);


--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY permisos (id, nombre, descripcion, created_at, updated_at) FROM stdin;
300	new_colegiados	\N	2011-06-22 12:28:51.05351	2011-06-22 12:28:51.05351
301	edit_colegiados	\N	2011-06-22 12:28:51.056209	2011-06-22 12:28:51.056209
302	index_colegiados	\N	2011-06-22 12:28:51.058203	2011-06-22 12:28:51.058203
303	new_expedientes	\N	2011-06-22 12:28:51.060244	2011-06-22 12:28:51.060244
304	edit_expedientes	\N	2011-06-22 12:28:51.062283	2011-06-22 12:28:51.062283
305	index_expedientes	\N	2011-06-22 12:28:51.06443	2011-06-22 12:28:51.06443
306	new_cursos	\N	2011-06-22 12:28:51.065864	2011-06-22 12:28:51.065864
307	edit_cursos	\N	2011-06-22 12:28:51.115061	2011-06-22 12:28:51.115061
308	index_cursos	\N	2011-06-22 12:28:51.116583	2011-06-22 12:28:51.116583
309	new_gestiones_documentales	\N	2011-06-22 12:28:51.166292	2011-06-22 12:28:51.166292
310	edit_gestiones_documentales	\N	2011-06-22 12:28:51.301729	2011-06-22 12:28:51.301729
311	index_gestiones_documentales	\N	2011-06-22 12:28:51.58785	2011-06-22 12:28:51.58785
312	new_remesas	\N	2011-06-22 12:28:51.60994	2011-06-22 12:28:51.60994
313	edit_remesas	\N	2011-06-22 12:28:51.621293	2011-06-22 12:28:51.621293
314	index_remesas	\N	2011-06-22 12:28:51.623231	2011-06-22 12:28:51.623231
315	new_transacciones	\N	2011-06-22 12:28:51.625278	2011-06-22 12:28:51.625278
316	edit_transacciones	\N	2011-06-22 12:28:51.626752	2011-06-22 12:28:51.626752
317	index_transacciones	\N	2011-06-22 12:28:51.628422	2011-06-22 12:28:51.628422
318	new_movimientos	\N	2011-06-22 12:28:51.630659	2011-06-22 12:28:51.630659
319	edit_movimientos	\N	2011-06-22 12:28:51.632659	2011-06-22 12:28:51.632659
320	index_movimientos	\N	2011-06-22 12:28:51.634238	2011-06-22 12:28:51.634238
321	index_caja_cuadres	\N	2011-06-22 12:28:51.636294	2011-06-22 12:28:51.636294
322	edit_caja_cuadres	\N	2011-06-22 12:28:51.638188	2011-06-22 12:28:51.638188
323	new_caja_cuadres	\N	2011-06-22 12:28:51.639669	2011-06-22 12:28:51.639669
324	new_colegios	\N	2011-06-22 12:28:51.641273	2011-06-22 12:28:51.641273
325	edit_colegios	\N	2011-06-22 12:28:51.643007	2011-06-22 12:28:51.643007
326	index_colegios	\N	2011-06-22 12:28:51.644492	2011-06-22 12:28:51.644492
327	delete_colegios	\N	2011-06-22 12:28:51.646286	2011-06-22 12:28:51.646286
328	new_usuarios	\N	2011-06-22 12:28:51.648177	2011-06-22 12:28:51.648177
329	edit_usuarios	\N	2011-06-22 12:28:51.650034	2011-06-22 12:28:51.650034
330	index_usuarios	\N	2011-06-22 12:28:51.651944	2011-06-22 12:28:51.651944
331	new_roles	\N	2011-06-22 12:28:51.653836	2011-06-22 12:28:51.653836
332	edit_roles	\N	2011-06-22 12:28:51.655698	2011-06-22 12:28:51.655698
333	index_roles	\N	2011-06-22 12:28:51.657539	2011-06-22 12:28:51.657539
334	new_permisos	\N	2011-06-22 12:28:51.659192	2011-06-22 12:28:51.659192
335	edit_permisos	\N	2011-06-22 12:28:51.66076	2011-06-22 12:28:51.66076
336	index_permisos	\N	2011-06-22 12:28:51.662171	2011-06-22 12:28:51.662171
337	new_paises	\N	2011-06-22 12:28:51.663629	2011-06-22 12:28:51.663629
338	edit_paises	\N	2011-06-22 12:28:51.665226	2011-06-22 12:28:51.665226
339	index_paises	\N	2011-06-22 12:28:51.666745	2011-06-22 12:28:51.666745
340	new_provincias	\N	2011-06-22 12:28:51.66837	2011-06-22 12:28:51.66837
341	edit_provincias	\N	2011-06-22 12:28:51.670151	2011-06-22 12:28:51.670151
342	index_provincias	\N	2011-06-22 12:28:51.671668	2011-06-22 12:28:51.671668
343	new_localidades	\N	2011-06-22 12:28:51.673042	2011-06-22 12:28:51.673042
344	edit_localidades	\N	2011-06-22 12:28:51.674437	2011-06-22 12:28:51.674437
345	index_localidades	\N	2011-06-22 12:28:51.675728	2011-06-22 12:28:51.675728
346	new_bancos	\N	2011-06-22 12:28:51.67701	2011-06-22 12:28:51.67701
347	edit_bancos	\N	2011-06-22 12:28:51.678538	2011-06-22 12:28:51.678538
348	index_bancos	\N	2011-06-22 12:28:51.679986	2011-06-22 12:28:51.679986
349	new_centros	\N	2011-06-22 12:28:51.681262	2011-06-22 12:28:51.681262
350	edit_centros	\N	2011-06-22 12:28:51.682621	2011-06-22 12:28:51.682621
351	index_centros	\N	2011-06-22 12:28:51.683953	2011-06-22 12:28:51.683953
352	new_profesiones	\N	2011-06-22 12:28:51.685378	2011-06-22 12:28:51.685378
353	edit_profesiones	\N	2011-06-22 12:28:51.686738	2011-06-22 12:28:51.686738
354	index_profesiones	\N	2011-06-22 12:28:51.68802	2011-06-22 12:28:51.68802
355	delete_profesiones	\N	2011-06-22 12:28:51.689283	2011-06-22 12:28:51.689283
356	new_especialidades	\N	2011-06-22 12:28:51.690654	2011-06-22 12:28:51.690654
357	edit_especialidades	\N	2011-06-22 12:28:51.691995	2011-06-22 12:28:51.691995
358	index_especialidades	\N	2011-06-22 12:28:51.69335	2011-06-22 12:28:51.69335
359	delete_especialidades	\N	2011-06-22 12:28:51.694724	2011-06-22 12:28:51.694724
360	new_informes	\N	2011-06-22 12:28:51.696128	2011-06-22 12:28:51.696128
361	edit_informes	\N	2011-06-22 12:28:51.697493	2011-06-22 12:28:51.697493
362	index_informes	\N	2011-06-22 12:28:51.698753	2011-06-22 12:28:51.698753
363	new_recibos	\N	2011-06-22 12:28:51.700046	2011-06-22 12:28:51.700046
364	edit_recibos	\N	2011-06-22 12:28:51.701427	2011-06-22 12:28:51.701427
365	index_recibos	\N	2011-06-22 12:28:51.702735	2011-06-22 12:28:51.702735
366	index_registro_entrada	\N	2011-06-22 12:28:51.704065	2011-06-22 12:28:51.704065
367	new_aulas	\N	2011-06-22 12:28:51.705353	2011-06-22 12:28:51.705353
368	index_aulas	\N	2011-06-22 12:28:51.706691	2011-06-22 12:28:51.706691
369	edit_aulas	\N	2011-06-22 12:28:51.708119	2011-06-22 12:28:51.708119
370	new_coordinadores	\N	2011-06-22 12:28:51.70951	2011-06-22 12:28:51.70951
371	new_curso_coordinadores	\N	2011-06-22 12:28:51.710896	2011-06-22 12:28:51.710896
372	index_coordinadores	\N	2011-06-22 12:28:51.712271	2011-06-22 12:28:51.712271
373	edit_coordinadores	\N	2011-06-22 12:28:51.713625	2011-06-22 12:28:51.713625
374	index_profesores	\N	2011-06-22 12:28:51.715031	2011-06-22 12:28:51.715031
375	new_profesores	\N	2011-06-22 12:28:51.716637	2011-06-22 12:28:51.716637
376	edit_profesores	\N	2011-06-22 12:28:51.717973	2011-06-22 12:28:51.717973
377	new_curso_profesores	\N	2011-06-22 12:28:51.719357	2011-06-22 12:28:51.719357
378	index_entidades_acreditadoras	\N	2011-06-22 12:28:51.720743	2011-06-22 12:28:51.720743
379	new_entidades_acreditadoras	\N	2011-06-22 12:28:51.722187	2011-06-22 12:28:51.722187
380	edit_entidades_acreditadoras	\N	2011-06-22 12:28:51.723567	2011-06-22 12:28:51.723567
381	index_formaciones	\N	2011-06-22 12:28:51.724859	2011-06-22 12:28:51.724859
382	edit_formaciones	\N	2011-06-22 12:28:51.726216	2011-06-22 12:28:51.726216
383	new_formaciones	\N	2011-06-22 12:28:51.727559	2011-06-22 12:28:51.727559
384	index_notas	\N	2011-06-22 12:28:51.72902	2011-06-22 12:28:51.72902
385	new_notas	\N	2011-06-22 12:28:51.730456	2011-06-22 12:28:51.730456
386	edit_notas	\N	2011-06-22 12:28:51.731725	2011-06-22 12:28:51.731725
387	delete_notas	\N	2011-06-22 12:28:51.733066	2011-06-22 12:28:51.733066
391	mis_datos_colegiados	\N	2011-06-22 12:59:00.734308	2011-06-22 13:00:09.297318
390	new_existing_permisos	\N	2011-06-22 12:34:59.377053	2011-06-22 12:34:59.377053
\.


--
-- Data for Name: permisos_roles; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY permisos_roles (permiso_id, rol_id) FROM stdin;
300	1
301	1
302	1
303	1
304	1
305	1
306	1
307	1
308	1
309	1
310	1
311	1
312	1
313	1
314	1
315	1
316	1
317	1
318	1
319	1
320	1
321	1
322	1
323	1
324	1
325	1
326	1
327	1
328	1
329	1
330	1
331	1
332	1
333	1
334	1
335	1
336	1
337	1
338	1
339	1
340	1
341	1
342	1
343	1
344	1
345	1
346	1
347	1
348	1
349	1
350	1
351	1
352	1
353	1
354	1
355	1
356	1
357	1
358	1
359	1
360	1
361	1
362	1
363	1
364	1
365	1
366	1
367	1
368	1
369	1
370	1
371	1
372	1
373	1
374	1
375	1
376	1
377	1
378	1
379	1
380	1
381	1
382	1
383	1
384	1
385	1
386	1
387	1
388	1
389	1
390	1
391	6
393	6
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY roles (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	admin	Administrador del sistema	2010-02-04 16:09:40.700974	2010-02-04 16:09:40.700974
3	contabilidad	Contabilidad	2010-02-11 20:46:21.489829	2010-02-11 20:46:21.489829
2	administracion	Administración	2010-02-11 20:46:08.261846	2010-02-22 12:04:49.445386
4	administradores	Administradores	2010-02-22 12:05:36.105436	2010-02-22 12:05:36.105436
6	usuarios	Usuarios	2011-06-20 12:39:22.884582	2011-06-20 12:39:22.884582
\.


--
-- Data for Name: roles_usuarios; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY roles_usuarios (rol_id, usuario_id) FROM stdin;
6	15
1	1
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY usuarios (id, login, nombre, apellido1, apellido2, rol, created_at, updated_at, origen_type, origen_id, password) FROM stdin;
1	admin	Administrador	\N	\N	\N	2010-02-04 16:07:13.806316	2011-06-20 12:37:45.363624	ldap	\N	d033e22ae348aeb5660fc2140aec35850c4da997
15	prueba	Prueba	\N	\N	\N	2011-06-20 12:38:34.109466	2011-06-20 12:40:46.265756	Colegiado	1	711383a59fda05336fd2ccf70c8059d1523eb41a
\.


--
-- PostgreSQL database dump complete
--
