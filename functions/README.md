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
          - Phone must be in the format [+1] (999) 000-0000
      - -5 Business Phone not in the correct format
        - Possible fixes
          - Phone must be in format [+1] (999) 000-0000
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
  - New Service
      - -3 Invalid part cost
        - Possible fixes
          - The part cost must be greater or equal to zero
      - -4 Invalid labor cost 
        - Possible fixes
          - The list price must be greater or equal to zero
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