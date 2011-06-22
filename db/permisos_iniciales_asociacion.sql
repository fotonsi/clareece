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

SELECT pg_catalog.setval('permisos_id_seq', 298, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: entrada
--

SELECT pg_catalog.setval('roles_id_seq', 6, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: entrada
--

SELECT pg_catalog.setval('usuarios_id_seq', 13, true);


--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY permisos (id, nombre, descripcion, created_at, updated_at) FROM stdin;
141	new_colegiados	Crear nuevo colegiado	2010-02-12 17:33:03.859543	2010-02-12 17:33:03.859543
142	edit_colegiados	Modificar datos de colegiado	2010-02-12 17:33:03.877908	2010-02-12 17:33:03.877908
144	index_colegiados	Listar colegiados	2010-02-12 17:33:03.887418	2010-02-12 17:33:03.887418
149	new_expedientes	Crear nuevo expediente	2010-02-12 17:33:03.907217	2010-02-12 17:33:03.907217
150	edit_expedientes	Modificar datos de expediente	2010-02-12 17:33:03.910358	2010-02-12 17:33:03.910358
152	index_expedientes	Listar expedientes	2010-02-12 17:33:03.919948	2010-02-12 17:33:03.919948
153	new_gestiones_documentales	Crear registro de E/S	2010-02-12 17:33:03.923758	2010-02-12 17:33:03.923758
154	edit_gestiones_documentales	Modificar datos de registro de E/S	2010-02-12 17:33:03.927003	2010-02-12 17:33:03.927003
156	index_gestiones_documentales	Listar registros de E/S	2010-02-12 17:33:03.936763	2010-02-12 17:33:03.936763
157	new_remesas	Crear nueva remesa	2010-02-12 17:33:03.940722	2010-02-12 17:33:03.940722
158	edit_remesas	Modificar datos de remesa	2010-02-12 17:33:03.943987	2010-02-12 17:33:03.943987
160	index_remesas	Listar remesas	2010-02-12 17:33:03.950229	2010-02-12 17:33:03.950229
161	new_transacciones	Crear nueva transacción	2010-02-12 17:33:03.954477	2010-02-12 17:33:03.954477
162	edit_transacciones	Modificar datos de transacción	2010-02-12 17:33:03.957899	2010-02-12 17:33:03.957899
164	index_transacciones	Listar transacciones	2010-02-12 17:33:03.966659	2010-02-12 17:33:03.966659
165	new_movimientos	Crear nuevo movimiento	2010-02-12 17:33:03.969729	2010-02-12 17:33:03.969729
166	edit_movimientos	Modificar datos de movimiento	2010-02-12 17:33:03.976863	2010-02-12 17:33:03.976863
168	index_movimientos	Listar movimientos	2010-02-12 17:33:03.983844	2010-02-12 17:33:03.983844
169	new_paises	Crear nuevo pais	2010-02-12 17:33:03.98698	2010-02-12 17:33:03.98698
170	edit_paises	Modificar datos de pais	2010-02-12 17:33:03.990275	2010-02-12 17:33:03.990275
172	index_paises	Listar paises	2010-02-12 17:33:04.000017	2010-02-12 17:33:04.000017
173	new_provincias	Crear nueva provincia	2010-02-12 17:33:04.00314	2010-02-12 17:33:04.00314
174	edit_provincias	Modificar datos de provincia	2010-02-12 17:33:04.01626	2010-02-12 17:33:04.01626
176	index_provincias	Listar provincias	2010-02-12 17:33:04.023431	2010-02-12 17:33:04.023431
177	new_localidades	Crear nueva localidad	2010-02-12 17:33:04.035912	2010-02-12 17:33:04.035912
178	edit_localidades	Modificar datos de localidad	2010-02-12 17:33:04.043901	2010-02-12 17:33:04.043901
180	index_localidades	Listar localidades	2010-02-12 17:33:04.056246	2010-02-12 17:33:04.056246
181	new_bancos	Crear nuevo banco	2010-02-12 17:33:04.059643	2010-02-12 17:33:04.059643
182	edit_bancos	Modificar datos de banco	2010-02-12 17:33:04.06276	2010-02-12 17:33:04.06276
184	index_bancos	Listar bancos	2010-02-12 17:33:04.068856	2010-02-12 17:33:04.068856
185	new_centros	Crear nuevo centro	2010-02-12 17:33:04.075202	2010-02-12 17:33:04.075202
186	edit_centros	Modificar datos de centro	2010-02-12 17:33:04.07847	2010-02-12 17:33:04.07847
188	index_centros	Listar centros	2010-02-12 17:33:04.084584	2010-02-12 17:33:04.084584
189	new_profesiones	Crear nueva profesion	2010-02-12 17:33:04.08765	2010-02-12 17:33:04.08765
190	edit_profesiones	Modificar datos de profesion	2010-02-12 17:33:04.093816	2010-02-12 17:33:04.093816
192	index_profesiones	Listar profesiones	2010-02-12 17:33:04.100127	2010-02-12 17:33:04.100127
193	new_especialidades	Crear nueva especialidad	2010-02-12 17:33:04.103137	2010-02-12 17:33:04.103137
194	edit_especialidades	Modificar datos de especialidad	2010-02-12 17:33:04.106177	2010-02-12 17:33:04.106177
196	index_especialidades	Listar especialidades	2010-02-12 17:33:04.115451	2010-02-12 17:33:04.115451
197	new_usuarios	Crear nuevo usuario	2010-02-12 17:33:04.118731	2010-02-12 17:33:04.118731
198	edit_usuarios	Modificar datos de usuario	2010-02-12 17:33:04.121777	2010-02-12 17:33:04.121777
200	index_usuarios	Listar usuarios	2010-02-12 17:33:04.12779	2010-02-12 17:33:04.12779
201	new_roles	Crear nuevo rol	2010-02-12 17:33:04.130846	2010-02-12 17:33:04.130846
202	edit_roles	Modificar datos de rol	2010-02-12 17:33:04.137088	2010-02-12 17:33:04.137088
204	index_roles	Listar roles	2010-02-12 17:33:04.143814	2010-02-12 17:33:04.143814
205	new_permisos	Crear nuevo permiso	2010-02-12 17:33:04.146845	2010-02-12 17:33:04.146845
206	edit_permisos	Modificar datos de permiso	2010-02-12 17:33:04.150251	2010-02-12 17:33:04.150251
208	index_permisos	Listar permisos	2010-02-12 17:33:04.1598	2010-02-12 17:33:04.1598
209	new_colegiados	Crear nuevo colegiado	2010-03-05 11:16:01.759633	2010-03-05 11:16:01.759633
210	edit_colegiados	Modificar datos de colegiado	2010-03-05 11:16:01.799921	2010-03-05 11:16:01.799921
212	index_colegiados	Listar colegiados	2010-03-05 11:16:01.804534	2010-03-05 11:16:01.804534
217	new_expedientes	Crear nuevo expediente	2010-03-05 11:16:01.815827	2010-03-05 11:16:01.815827
218	edit_expedientes	Modificar datos de expediente	2010-03-05 11:16:01.819942	2010-03-05 11:16:01.819942
220	index_expedientes	Listar expedientes	2010-03-05 11:16:01.82412	2010-03-05 11:16:01.82412
221	new_gestiones_documentales	Crear registro de E/S	2010-03-05 11:16:01.826195	2010-03-05 11:16:01.826195
222	edit_gestiones_documentales	Modificar datos de registro de E/S	2010-03-05 11:16:01.828483	2010-03-05 11:16:01.828483
224	index_gestiones_documentales	Listar registros de E/S	2010-03-05 11:16:01.832628	2010-03-05 11:16:01.832628
225	new_remesas	Crear nueva remesa	2010-03-05 11:16:01.834682	2010-03-05 11:16:01.834682
226	edit_remesas	Modificar datos de remesa	2010-03-05 11:16:01.837257	2010-03-05 11:16:01.837257
228	index_remesas	Listar remesas	2010-03-05 11:16:01.841471	2010-03-05 11:16:01.841471
229	new_transaccions	Crear nueva transacción	2010-03-05 11:16:01.843516	2010-03-05 11:16:01.843516
230	edit_transaccions	Modificar datos de transacción	2010-03-05 11:16:01.845556	2010-03-05 11:16:01.845556
232	index_transaccions	Listar transacciones	2010-03-05 11:16:01.849621	2010-03-05 11:16:01.849621
233	new_movimientos	Crear nuevo movimiento	2010-03-05 11:16:01.853278	2010-03-05 11:16:01.853278
234	edit_movimientos	Modificar datos de movimiento	2010-03-05 11:16:01.85554	2010-03-05 11:16:01.85554
236	index_movimientos	Listar movimientos	2010-03-05 11:16:01.864347	2010-03-05 11:16:01.864347
238	index_informes	Listar informes	2010-03-19 19:03:56.173876	2010-03-19 19:03:56.173876
239	edit_colegios	Datos de configuración del colegio	2010-04-08 07:29:07.034602	2010-04-08 07:29:07.034602
240	new_recibos	Crear recibos	2010-06-10 10:57:10.61709	2010-06-10 10:57:10.61709
242	index_recibos	Listar recibos	2010-06-10 11:03:56.659423	2010-06-10 11:03:56.659423
243	edit_recibos	Editar recibos	2010-06-10 11:08:08.916884	2010-06-10 11:08:08.916884
245	index_registro_entrada	Listar entrada del registro	2010-06-16 16:39:41.453556	2010-06-16 16:39:41.453556
246	new_informes	Crear nuevo Informe	2010-06-16 17:52:01.743085	2010-06-16 17:52:01.743085
247	edit_informes	Modificar datos de informes	2010-06-16 17:52:18.02403	2010-06-16 17:52:18.02403
248	delete_informes	Borrar informes	2010-06-16 17:52:48.789347	2010-06-16 17:52:48.789347
250	index_caja_cuadres	Cuadres de caja	2010-06-17 12:34:17.772543	2010-06-17 12:34:17.772543
251	edit_caja_cuadres	Modificar cuadres de caja	2010-06-17 12:34:40.228922	2010-06-17 12:34:40.228922
252	new_caja_cuadres	Hacer cuadre de caja	2010-06-17 12:34:54.097904	2010-06-17 12:34:54.097904
272	index_colegios	\N	2011-01-27 12:25:57.782077	2011-01-27 12:25:57.782077
273	delete_colegios	\N	2011-01-27 12:26:02.693223	2011-01-27 12:26:02.693223
274	index_colegios	\N	2011-01-27 12:30:48.580487	2011-01-27 12:30:48.580487
275	delete_colegios	\N	2011-01-27 12:30:52.743248	2011-01-27 12:30:52.743248
276	index_colegios	\N	2011-01-27 12:31:39.151183	2011-01-27 12:31:39.151183
277	delete_colegios	\N	2011-01-27 12:31:42.22413	2011-01-27 12:31:42.22413
278	index_colegios	\N	2011-01-27 12:31:56.64009	2011-01-27 12:31:56.64009
279	delete_colegios	\N	2011-01-27 12:31:59.55723	2011-01-27 12:31:59.55723
280	index_notas	\N	2011-01-27 16:10:08.120061	2011-01-27 16:10:08.120061
281	new_notas	\N	2011-01-27 16:10:08.159664	2011-01-27 16:10:08.159664
282	edit_notas	\N	2011-01-27 16:10:08.16862	2011-01-27 16:10:08.16862
283	delete_notas	\N	2011-01-27 16:10:08.177297	2011-01-27 16:10:08.177297
284	index_notas	\N	2011-01-27 16:10:08.187598	2011-01-27 16:10:08.187598
285	new_notas	\N	2011-01-27 16:10:08.196281	2011-01-27 16:10:08.196281
286	edit_notas	\N	2011-01-27 16:10:08.204852	2011-01-27 16:10:08.204852
287	delete_notas	\N	2011-01-27 16:10:08.21343	2011-01-27 16:10:08.21343
288	index_notas	\N	2011-01-27 16:10:08.22365	2011-01-27 16:10:08.22365
289	new_notas	\N	2011-01-27 16:10:08.232349	2011-01-27 16:10:08.232349
290	edit_notas	\N	2011-01-27 16:10:08.240969	2011-01-27 16:10:08.240969
291	delete_notas	\N	2011-01-27 16:10:08.249553	2011-01-27 16:10:08.249553
292	delete_profesiones	\N	2011-02-02 13:58:38.566918	2011-02-02 13:58:38.566918
297	delete_especialidades	\N	2011-02-02 14:07:32.186681	2011-02-02 14:07:32.186681
298	mis_datos_colegiados	Mis datos	2011-06-20 12:39:54.009224	2011-06-20 12:39:54.009224
\.


--
-- Data for Name: permisos_roles; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY permisos_roles (permiso_id, rol_id) FROM stdin;
141	1
142	1
144	1
145	1
146	1
148	1
149	1
150	1
152	1
153	1
154	1
156	1
157	1
158	1
160	1
161	1
162	1
164	1
165	1
166	1
168	1
169	1
170	1
172	1
173	1
174	1
176	1
177	1
178	1
180	1
181	1
182	1
184	1
185	1
186	1
188	1
189	1
190	1
192	1
193	1
194	1
196	1
197	1
198	1
200	1
201	1
202	1
204	1
205	1
206	1
208	1
141	2
142	2
144	2
145	2
146	2
148	2
149	2
150	2
152	2
153	2
154	2
156	2
169	2
170	2
172	2
173	2
174	2
176	2
177	2
178	2
180	2
181	2
182	2
184	2
185	2
186	2
188	2
160	3
161	3
162	3
164	3
165	3
166	3
157	3
168	3
158	3
141	4
142	4
144	4
145	4
146	4
148	4
149	4
150	4
152	4
153	4
154	4
156	4
157	4
158	4
160	4
161	4
162	4
164	4
165	4
166	4
168	4
169	4
170	4
172	4
173	4
174	4
176	4
177	4
178	4
180	4
181	4
182	4
184	4
185	4
186	4
188	4
189	4
190	4
192	4
193	4
194	4
196	4
197	4
198	4
200	4
201	4
202	4
204	4
205	4
206	4
208	4
238	1
238	2
238	3
238	4
239	4
240	1
242	1
240	4
242	4
243	4
245	4
246	4
247	4
248	4
250	4
251	4
252	4
253	4
255	4
256	4
257	4
258	4
259	4
261	4
262	4
263	4
264	4
265	4
266	4
267	4
268	4
269	4
270	4
271	4
255	2
253	2
256	2
262	2
263	2
264	2
265	2
257	2
258	2
259	2
261	2
250	3
251	3
252	3
269	2
270	2
271	2
165	2
166	2
168	2
233	2
234	2
236	2
250	2
251	2
252	2
238	2
246	2
247	2
248	2
272	1
273	1
274	4
275	4
276	3
277	3
278	2
279	2
280	2
281	2
282	2
283	2
284	3
285	3
286	3
287	3
288	4
289	4
290	4
291	4
192	2
189	2
190	2
192	2
189	2
190	2
292	2
192	3
189	3
190	3
292	3
192	4
189	4
190	4
292	4
196	2
193	2
194	2
297	2
196	3
193	3
194	3
297	3
196	4
193	4
194	4
297	4
298	6
150	6
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
3	1
4	1
2	1
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: entrada
--

COPY usuarios (id, login, nombre, apellido1, apellido2, rol, created_at, updated_at, origen_type, origen_id, password) FROM stdin;
1	admin	Administrador	\N	\N	\N	2010-02-04 16:07:13.806316	2010-02-23 10:36:08.854156	ldap	\N	d033e22ae348aeb5660fc2140aec35850c4da997
\.


--
-- PostgreSQL database dump complete
--

