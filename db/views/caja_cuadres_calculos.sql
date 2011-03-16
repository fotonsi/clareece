DROP VIEW caja_cuadres_calculos;
CREATE VIEW caja_cuadres_calculos AS
SELECT *, (cent_1+cent_2+cent_5+cent_10+cent_20+cent_50+eur_1+eur_2) AS num_mon,
	  (eur_5+eur_10+eur_20+eur_50+eur_100+eur_200+eur_500) AS num_bill,
          (cent_1*0.01+cent_2*0.02+cent_5*0.05+cent_10*0.1+cent_20*0.2+cent_50*0.5+eur_1+eur_2*2) AS tot_mon,
          (eur_5*5+eur_10*10+eur_20*20+eur_50*50+eur_100*100+eur_200*200+eur_500*500) AS tot_bill,
	  cent_1*0.01 as tot_c_1, cent_2*0.02 as tot_c_2, cent_5*0.05 as tot_c_5, cent_10*0.10 as tot_c_10,
	  cent_20*0.20 as tot_c_20, cent_50*0.50 as tot_c_50, eur_1*1.00 as tot_e_1, eur_2*2.00 as tot_e_2,
	  eur_5*5 as tot_e_5, eur_10*10 as tot_e_10, eur_20*20 as tot_e_20, eur_50*50 as tot_e_50,
          eur_100*100 as tot_e_100, eur_200*200 as tot_e_200, eur_500*500 as tot_e_500
FROM caja_cuadres;
