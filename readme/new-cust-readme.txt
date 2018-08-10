path to the main shell script called menu:
tcsh menu
......................
If the user selects 'c' then ........................
.......................
<the rest of the program execution>
........................
If the user selects 'c' the menu shell script calls new-vehicle.sql script to create a new vehicle.
new-vehicle.sql uses NEW_VEHICLE procedure by passing 15 parameters which are an IN parameters and the other 
is an OUT parameter. The IN parameters are the serial number(serial), the make of the car (make), the model
(model, the year (cyear) the color (color),, trim (trim), Type of engine (enginetype), Customers name of owner (cname)
, the purchase invoice number (purchinv), the purchase date (purchdate), Who the car was purchased from
, The cost of purchasing the car (purchcost), the cost to ship the car to the destination (frieght cost)
, the cost at wich the car was listed (list price) and the OUT parameter is a SMALLINT that will hold the exit code of the procedure.
Here is a sample of the program execution:

 Enter your option here: c
Enter the information bellow to insert a new vehicle

     Enter the car serial number: 5GHH
     Enter the make of the car: ACURA
     Enter the model of the car: CX
     Enter the year of the car: 2013
     Enter the color of the car: red
     Enter the trim of the car: red
     Enter the type of engine the car contains: 4 Cyli
     Enter the owner of the car: NP
     Enter the invoice number of the purchase order: NPT11
     Enter the date in which the car was purchased: 2018/08/08
     Enter the business or the person the car was purchased from: 
     Enter the cost specialty imports paid to acquire the car:NPT
     Enter the cost to import the car: 0
     Enter the priced in which th car is listed: 30000


The car with serial &p_serial was inserted into the database
....................
The error code returned by the procedure can be mapped using the following list: 

Error Codes:
  - General:
      - -1: Internal server error
        - Possible fixes
          - restart DB
      - -2: Primary key already exists in the database
        - Possible fixes
          - Change primary key value
  - New Customer:
      - -3 Postal Code is not in the correct format
        - Possible fixes
          - Postal must be in format V5V V5V or 11111
      - -4 Home Phone is not in the correct format
        - Possible fixes
          - Phone must be in the format (999)000-0000
      - -5 Business Phone not in the correct format
        - Possible fixes
          - Phone must be in format (999)000-0000