/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas; 
caslib _all_ assign;


data PUBLIC.TEST_ID;
	ACCOUNT_FIRST = '40817810987870008924';
	ACCOUNT_SECOND = '40817810287870008925';
run;

proc casutil;
	promote casdata="TEST_ID" casout="TEST_ID"
	incaslib="PUBLIC" outcaslib="PUBLIC";
quit;