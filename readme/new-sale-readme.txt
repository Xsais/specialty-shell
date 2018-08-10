path to the main shell script called menu:
tcsh menu
......................
If the user selects 'a' then ........................
.......................
<the rest of the program execution>
........................
If the user selects 'a' the menu shell script calls new-sale.sql script to create a new sale. 
new_sale.sql uses NEW_SALE procedure by passing 15 parameters which are several IN parameters and the other 
is an OUT parameter. The IN parameters are the The invoic number of the sale (saleinv), te customer that made the sale (cname), the sales man, the the sales date
, the serial number, the total price, the discount ammount, the lic fee, the commision of the sales man
, the trade-in serial, the ammunt allowed for the trade (tradeallow), was fir insurance purchased
, was collision insurence purchased, was liability insurence purschese
, was property isurence purchased and the OUT parameter is a SMALLINT that will hold the exit code of the procedure.
Here is a sample of the program execution:

 Enter your option here: a
Enter the information bellow to create a new sale

     Enter the invoice for the sale: HHTY
     Enter the customer that made the purchase: NP
     Enter the employee that made the sale: EMP1
     Enter the date in which the sale was made: 2013/03/01
     Enter the serial of the car sold: NPP19
     Enter the selling price for the car: 30000
     Enter the discount for this sale: 0
     Enter the amount paid for the license: 0
     Enter the commission EMP1 made on the sale: 0
     Enter the serial of the car that was traded in: 0
     Enter the allowed discount from the trade in: 0
     Did the custer purchase fire insurance? n
     Did the custer purchase insurance insurance? n
     Did the custer purchase liability insurance? n
     Did the custer purchase property insurance? n


The sale with an invoice number of HHTY was added to the database
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
  - New Sale
      - -3 Invalid total price
        - Possible fixes
          - The total price must be greater or equal to zero
      - -4 Invalid discount price
        - Possible fixes
          - The discount price must be greater or equal to zero
      - -5 Invalid license fee
        - Possible fixes
          - The license fee must be greater or equal to zero
      - -6 Invalid commision
        - Possible fixes
          - The commision must be greater or equal to zero
      - -7 Invalid trade allowance
        - Possible fixes
          - The trade allowance must be greater or equal to zero
      - -8 Invalid fire option
        - Possible fixes
          - The fire option must be yes or no
      - -9 Invalid collision option
        - Possible fixes
          - The collision option must be yes or no
      - -10 Invalid liability option
        - Possible fixes
          - The liability option must be yes or no
      - -11 Invalid property option
        - Possible fixes
          - The property option must be yes or no