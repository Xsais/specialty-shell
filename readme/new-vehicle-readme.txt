path to the main shell script called menu:
tcsh menu
......................
If the user selects 'a' then ........................
.......................
<the rest of the program execution>
........................
If the user selects 'a' the menu shell script calls new-customer.sql script to create a new customer. 
new_customer.sql uses NEW_CUSTOMER procedure by passing nine parameters which are an IN parameters and the other 
is an OUT parameter. The IN parameters are the customer name (cname), the custumors street (cstreet), the customers 
city (ccity), the customers Province(cprov) the customers Postal code (cpostal), both the customers bussiness and 
home phone(bhphone, chphone) and the OUT parameter is a SMALLINT that will hold the exit code of the procedure.
Here is a sample of the program execution:

 Enter your option here: a
Enter the information bellow to insert a new customer

     Enter the desired customer name: NP
     Enter NP's address: 123
     Enter NP's city: Oakville
     Enter NP's province: ON
     Enter NP's postal code: L6H 1M8
     Enter NP's home phone number: (000)000-0000
     Enter NP's business phone number: (000)000-0000


A customer with the name of NP already exits
....................
The error code returned by th procedure can be mapped using the following list: 

Error Codes:
  - General:
      - -1: Internal server error
        - Possible fixes
          - restart DB
      - -2: Primary key already exists in the database
        - Possible fixes
          - Change primary key value
  - New Vehicle
      - -3 Invalid purchase cost
        - Possible fixes
          - The purchase cost must be greater or equal to zero
      - -4 Invalid freight cost
        - Possible fixes
          - The freight cost must be greater or equal to zero
      - -5 Invalid list price
        - Possible fixes
          - The list price must be greater or equal to zero