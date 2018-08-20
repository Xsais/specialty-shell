#!/bin/tcsh -f

alias sql 'sqlplus -S <username>/<password>@aces'

while (1 == 1)
        clear
        cat menu.txt
        echo -n "Enter your option here: "
        set option = $<
        switch ( $option )
            case [aA]:
               echo ""
               sql @Create/new_customer.sql
            breaksw

            case [bB]:
               echo ""
               echo "Please Enter the Following Prompts to Generate the Customer Report:"
               sql @Inquiry/Customer_Inquiry.sql
            breaksw

            case [cC]:
               echo ""
               sql @Create/new_vehicle.sql
            breaksw

            case [dD]:
               echo ""
               echo "Please Enter the Following Prompts to Generate the Vehicle Inventory Report:"
               sql @Inquiry/Vehicle_Inventory_Record.sql
            breaksw

            case [eE]:
               echo ""
               sql @Create/new_sales.sql
            breaksw

            case [fF]:
               echo ""
               echo "Please Enter the Following Prompts to Generate the Sales Invoice Report:"
               sql @Inquiry/Sales_Invoice.sql
            breaksw

            case [gG]:
               echo ""
               sql @Create/new_service.sql
            breaksw

            case [hH]:
               echo ""
               echo "Please Enter the Following Prompts to Generate the Service Work Order Report:"
               sql @Inquiry/Service_Work_Order.sql
            breaksw

            case [iI]:
               echo ""
               sql @Create/new_prospect.sql
            breaksw

            case [jJ]:
               echo ""
               echo "Please Enter the Following Prompts to Generate the Prospective Customer Information Report:"
               sql @Inquiry/Single_Prospect.sql
            breaksw

            case [kK]:
               echo ""
               sql @Inquiry/Prospect_List.sql
            breaksw

            case [lL]:
               echo ""
               sql @Delete/delete_prospect.sql
            breaksw

            case [qQxX]:
               echo ""
               exit
            breaksw

            case *:
               echo "Invalid Option, please try again"
               breaksw
        endsw
        echo ""
        echo "Press any key to continue .....\c"
        set dummy = $<
end
