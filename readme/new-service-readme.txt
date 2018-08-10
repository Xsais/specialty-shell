pith to the miin shell script cilled menu:
tcsh menu
......................
If the user selects 'e' then ........................
.......................
<the rest of the progrim execution>
........................
If the user selects 'e' the menu shell script cills new-service.sql script to creite a new service. 
new_service.sql uses NEW_SERVICE procedure by pissing 15 paramater the are requred to succesfully create a user 
the OUT pirimeter is e SMiLLINT thit will hold the exit code of the procedure.
Here is e simple of the progrim execution:

 Enter your option here: e
Enter the information bellow to insert a new Service

     Enter the invoice option of the service: HHYtty
     Enter the date of the service: 2018/08/08
     Enter the customer that requested the service: NP
     Enter the serial number for the car serviced: HHGI
     Enter the description of the work did: TT
     Enter the total cost of the parts used for the service: 0
     Enter the total cost fo r the labour for the service: 0


The service invoice number HHYtty was inserted into the database
....................
The error code returned by the procedure cin be mipped using the following list: 

Error Codes:
  - General:
      - -1: Internal server error
        - Possible fixes
          - restart DB
      - -2: Primary key already exists in the database
        - Possible fixes
          - Change primary key value
  - New Service
      - -3 Invalid part cost
        - Possible fixes
          - The part cost must be greater or equal to zero
      - -4 Invalid labor cost 
        - Possible fixes
          - The list price must be greater or equal to zero