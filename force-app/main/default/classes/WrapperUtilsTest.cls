@isTest
public class WrapperUtilsTest {
    
    public static testmethod void wrapperUtilstestMethod() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        customSetting.MappingGasStayTime__c = true;
        customSetting.ContactTriggersendEmailForNewContact__c = true;
        customSetting.ContactTriCommunityReimCreate__c = true;
        customSetting.Mileage_Lockdate__c = false;
        insert customSetting;
        
        WrapperUtils obj_WrapperUtils = new WrapperUtils();
        List<IRS_Mileage_Rate__c> obj_IRS_Mileage_Rate =  RecordUtilityClass.insertIrsRate();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();
        
        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;       

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        insert obj_Driver_list;

        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;

        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        insert obj_Employee_Reimbursement_list;       
        
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;

        List<Employee_Reimbursement__c> obj_newreimbursements = new List<Employee_Reimbursement__c>();
        for(Contact obj:obj_Driver_list)
        {
            for(integer i=1;i<13;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year()-1);                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year()-1);              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            for(integer i=1;i<=12;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year());                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year());              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            
        }
        insert obj_newreimbursements;
        List<Employee_Mileage__c> obj_Employee_Mileage_list1 = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_newreimbursements);
        insert obj_Employee_Mileage_list1;

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List3 = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List3);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();
    

        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list2=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list6=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list6!=null && obj_EmployeeMileages_list6.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list6)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
                    obj_EmployeeMileages_list2.add(obj);
                }
                else
                {
                    i--;
                    obj.isChecked = true;
                    obj_EmployeeMileages_list1.add(obj);
                }
            }
        }
        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_list_update = new List<Employee_Reimbursement__c>();
        List<string> obj_Employee_Reimbursement_list_update1 = new List<string>();
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj_Employee_Reimbursement_list_update1.add(obj.id);
        }
        EmployeeReimbursements obj_EmployeeReimbursements = WrapperUtils.getEmployeeReimbursements(obj_Employee_Reimbursement_list[0]);
        List<EmployeeReimbursements> obj_EmployeeReimbursements_list2 = new List<EmployeeReimbursements>();
        obj_EmployeeReimbursements_list2.add(obj_EmployeeReimbursements);
        for(Employee_Reimbursement__c obj:obj_Employee_Reimbursement_list)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        update obj_Employee_Reimbursement_list_update;

        WrapperUtils.getChartData(obj_admincontact.id,obj_admincontact.showTeamRecord__c,obj_Account.id,'Driver');
        WrapperUtils.getComplianceCalculation(obj_Driver_list[0].id,String.valueOf(System.Today().year()));
        List<Contact> obj_updated_Driver_list =  new List<Contact>();
        for(Contact obj_contact:obj_Driver_list)
        {
            obj_contact.Deactivated_Date__c = system.today();
            obj_contact.Last_Pay_Date__c = system.today();
            obj_contact.Driving_States__c='AK;AL;';
            obj_updated_Driver_list.add(obj_contact);
        }
        update obj_updated_Driver_list;
 
        WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');

        obj_admincontact.showTeamRecord__c = true;
        update obj_admincontact;
        Test.startTest();
            WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');
            EmployeeDetails obj_EmployeeDetails = WrapperUtils.getEmployeeDetails(obj_Driver_list[0],110.50,230.50);
            List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
            obj_list_EmployeeDetails1.add(obj_EmployeeDetails);
            
            WrapperUtils.getContact(obj_EmployeeDetails);
            WrapperUtils.getNewContact(obj_EmployeeDetails);
            WrapperUtils.getMonthName('11-2019');
            WrapperUtils.getMonthno('November');
            WrapperUtils.getMonthandYear('November');
            WrapperUtils.getMileagesOfReimbursement(obj_list_mileages[0]);
            WrapperUtils.getLastMonthValue(-1);
        
            WrapperUtils.getPacketandMeetingDetails(obj_Driver_list[0].id);
            List<String> reimbusementidList = new List<String>();
            reimbusementidList.add(obj_Employee_Reimbursement_list_update1[0]);
            WrapperUtils.updateReimbursements(JSON.serialize(reimbusementidList));
            WrapperUtils.updateContactThresholdLimit(JSON.serialize(obj_Employee_Reimbursement_list));
            WrapperUtils.getManager(obj_Driver_list[0].id,obj_admincontact.id);
            WrapperUtils.getadminname(obj_Driver_list[0].id);
            Attachment att = new Attachment();
            att.parentID = obj_Driver_list[0].Id;
            att.name = 'test';
            att.body = blob.valueOf('Test');
            insert att;
            WrapperUtils.getDriverGasPrice('CA','ON');
            WrapperUtils.getAllReimbursements(String.valueOf(System.today().Year()),String.valueOf(obj_Driver_list[0].id),obj_Account.id);
            WrapperUtils.getReimbursementsList(obj_Driver_list[0].id,'Approved');
	Test.stopTest();   
    }
  
    public static testmethod void wrapperUtilstestMethod1() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        customSetting.MappingGasStayTime__c = true;
        customSetting.ContactTriggersendEmailForNewContact__c = true;
        customSetting.ContactTriCommunityReimCreate__c = true;
        customSetting.Mileage_Lockdate__c = false;
        insert customSetting;
        
        WrapperUtils obj_WrapperUtils = new WrapperUtils();
        List<IRS_Mileage_Rate__c> obj_IRS_Mileage_Rate =  RecordUtilityClass.insertIrsRate();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;       

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        for(Contact currentContact:obj_Driver_list)
        {
            currentContact.compliancestatus__c='No – Vehicle Age';
        }
        insert obj_Driver_list;
        
        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;

        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        insert obj_Employee_Reimbursement_list;     

        EmployeeReimbursementDetailsAdmin empClass = new EmployeeReimbursementDetailsAdmin(); 
        empClass = WrapperUtils.getEmployeeReimbursementDetails(obj_Employee_Reimbursement_list[0]); 
        WrapperUtils.getMonthNamefromno(11);
        
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;

        List<Employee_Reimbursement__c> obj_newreimbursements = new List<Employee_Reimbursement__c>();
        for(Contact obj:obj_Driver_list)
        {
            for(integer i=1;i<13;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year()-1);                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year()-1);              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            for(integer i=1;i<=12;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year());                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year());              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            
        }
        insert obj_newreimbursements;
    
        List<Employee_Mileage__c> obj_Employee_Mileage_list1 = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_newreimbursements);
        insert obj_Employee_Mileage_list1;

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List3 = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List3);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();
    

        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list2=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list6=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list6!=null && obj_EmployeeMileages_list6.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list6)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
                    obj_EmployeeMileages_list2.add(obj);
                }
                else
                {
                    i--;
                    obj.isChecked = true;
                    obj_EmployeeMileages_list1.add(obj);
                }
                
            }
        }
    // WrapperUtils.approveMileagesForAdminDash(JSON.serialize(obj_EmployeeMileages_list1),JSON.serialize(obj_EmployeeMileages_list2));
    
        
        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_list_update = new List<Employee_Reimbursement__c>();
        List<string> obj_Employee_Reimbursement_list_update1 = new List<string>();
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            
            obj_Employee_Reimbursement_list_update1.add(obj.id);
        }
    

        EmployeeReimbursements obj_EmployeeReimbursements = WrapperUtils.getEmployeeReimbursements(obj_Employee_Reimbursement_list[0]);
        List<EmployeeReimbursements> obj_EmployeeReimbursements_list2 = new List<EmployeeReimbursements>();
        obj_EmployeeReimbursements_list2.add(obj_EmployeeReimbursements);
        
        
        for(Employee_Reimbursement__c obj:obj_Employee_Reimbursement_list)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        update obj_Employee_Reimbursement_list_update;
       
        WrapperUtils.getChartData(obj_admincontact.id,obj_admincontact.showTeamRecord__c,obj_Account.id,'Driver');
        WrapperUtils.getComplianceCalculation(obj_Driver_list[0].id,String.valueOf(System.Today().year()));
        List<Contact> obj_updated_Driver_list =  new List<Contact>();
        for(Contact obj_contact:obj_Driver_list)
        {
            obj_contact.Deactivated_Date__c = system.today();
            obj_contact.Last_Pay_Date__c = system.today();
            obj_contact.Driving_States__c='AK;AL;';
            obj_updated_Driver_list.add(obj_contact);
        }
        update obj_updated_Driver_list;

        
        WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');

        obj_admincontact.showTeamRecord__c = true;
        update obj_admincontact;
        Test.startTest();
            WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');
            EmployeeDetails obj_EmployeeDetails = WrapperUtils.getEmployeeDetails(obj_Driver_list[0],110.50,230.50);
            List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
            obj_list_EmployeeDetails1.add(obj_EmployeeDetails);
            
            WrapperUtils.getContact(obj_EmployeeDetails);
            WrapperUtils.getNewContact(obj_EmployeeDetails);
            WrapperUtils.getMonthName('11-2019');
            WrapperUtils.getMonthno('November');
            WrapperUtils.getMonthandYear('November');
            WrapperUtils.getMileagesOfReimbursement(obj_list_mileages[0]);
            WrapperUtils.getLastMonthValue(-1);
        
            WrapperUtils.getPacketandMeetingDetails(obj_Driver_list[0].id);
            List<String> reimbusementidList = new List<String>();
            reimbusementidList.add(obj_Employee_Reimbursement_list_update1[0]);
            WrapperUtils.updateReimbursements(JSON.serialize(reimbusementidList));
            WrapperUtils.updateContactThresholdLimit(JSON.serialize(obj_Employee_Reimbursement_list));
            WrapperUtils.getManager(obj_Driver_list[0].id,obj_admincontact.id);
            WrapperUtils.getadminname(obj_Driver_list[0].id);
            Attachment att = new Attachment();
            att.parentID = obj_Driver_list[0].Id;
            att.name = 'test';
            att.body = blob.valueOf('Test');
            insert att;
			WrapperUtils.getMileages('November','2019',obj_Driver_list[0].id);
			WrapperUtils.getMileages1('November',String.valueOf(system.today().year()),obj_Driver_list[0].id);
	        WrapperUtils.getpastYearReimbursement(obj_Driver_list[0].id);
        Test.stopTest();   
    }
    
    public static testmethod void wrapperUtilstestMethod2() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        customSetting.MappingGasStayTime__c = true;
        customSetting.ContactTriggersendEmailForNewContact__c = true;
        customSetting.ContactTriCommunityReimCreate__c = true;
        customSetting.Mileage_Lockdate__c = false;
        insert customSetting;
        
        WrapperUtils obj_WrapperUtils = new WrapperUtils();
        List<IRS_Mileage_Rate__c> obj_IRS_Mileage_Rate =  RecordUtilityClass.insertIrsRate();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;       

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        for(Contact currentContact:obj_Driver_list)
        {
            currentContact.compliancestatus__c='Resubmit Insurance – you submitted an insurance card';
        }
        insert obj_Driver_list;
        
        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;

        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        insert obj_Employee_Reimbursement_list;       
        
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;

        List<Employee_Reimbursement__c> obj_newreimbursements = new List<Employee_Reimbursement__c>();
    for(Contact obj:obj_Driver_list)
        {
            for(integer i=1;i<13;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year()-1);                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year()-1);              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            for(integer i=1;i<=12;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year());                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year());              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            
        }
        insert obj_newreimbursements;
    
        List<Employee_Mileage__c> obj_Employee_Mileage_list1 = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_newreimbursements);
        insert obj_Employee_Mileage_list1;

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List3 = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List3);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();
    

        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list2=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list6=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list6!=null && obj_EmployeeMileages_list6.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list6)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
                    obj_EmployeeMileages_list2.add(obj);
                }
                else
                {
                    i--;
                    obj.isChecked = true;
                    obj_EmployeeMileages_list1.add(obj);
                }
                
            }
        }
    // WrapperUtils.approveMileagesForAdminDash(JSON.serialize(obj_EmployeeMileages_list1),JSON.serialize(obj_EmployeeMileages_list2));
    
        
        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_list_update = new List<Employee_Reimbursement__c>();
        List<string> obj_Employee_Reimbursement_list_update1 = new List<string>();
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            
            obj_Employee_Reimbursement_list_update1.add(obj.id);
        }
        

        EmployeeReimbursements obj_EmployeeReimbursements = WrapperUtils.getEmployeeReimbursements(obj_Employee_Reimbursement_list[0]);
        List<EmployeeReimbursements> obj_EmployeeReimbursements_list2 = new List<EmployeeReimbursements>();
        obj_EmployeeReimbursements_list2.add(obj_EmployeeReimbursements);
        
        
        for(Employee_Reimbursement__c obj:obj_Employee_Reimbursement_list)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        update obj_Employee_Reimbursement_list_update;

        WrapperUtils.getChartData(obj_admincontact.id,obj_admincontact.showTeamRecord__c,obj_Account.id,'Driver');
        WrapperUtils.getComplianceCalculation(obj_Driver_list[0].id,String.valueOf(System.Today().year()));
        List<Contact> obj_updated_Driver_list =  new List<Contact>();
        for(Contact obj_contact:obj_Driver_list)
        {
            obj_contact.Deactivated_Date__c = system.today();
            obj_contact.Last_Pay_Date__c = system.today();
            obj_contact.Driving_States__c='AK;AL;';
            obj_updated_Driver_list.add(obj_contact);
        }
        update obj_updated_Driver_list;

        
        WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');

        obj_admincontact.showTeamRecord__c = true;
        update obj_admincontact;
        Test.startTest();
            WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');
            EmployeeDetails obj_EmployeeDetails = WrapperUtils.getEmployeeDetails(obj_Driver_list[0],110.50,230.50);
            List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
            obj_list_EmployeeDetails1.add(obj_EmployeeDetails);
            
            WrapperUtils.getContact(obj_EmployeeDetails);
            WrapperUtils.getNewContact(obj_EmployeeDetails);
            WrapperUtils.getMonthName('11-2019');
            WrapperUtils.getMonthno('November');
            WrapperUtils.getMonthandYear('November');
            WrapperUtils.getMileagesOfReimbursement(obj_list_mileages[0]);
            WrapperUtils.getLastMonthValue(-1);
        
            WrapperUtils.getPacketandMeetingDetails(obj_Driver_list[0].id);
            List<String> reimbusementidList = new List<String>();
            reimbusementidList.add(obj_Employee_Reimbursement_list_update1[0]);
            WrapperUtils.updateReimbursements(JSON.serialize(reimbusementidList));
            WrapperUtils.updateContactThresholdLimit(JSON.serialize(obj_Employee_Reimbursement_list));
            WrapperUtils.getManager(obj_Driver_list[0].id,obj_admincontact.id);
            WrapperUtils.getadminname(obj_Driver_list[0].id);
            // ManagerDashboard Class Methods
            Attachment att = new Attachment();
            att.parentID = obj_Driver_list[0].Id;
            att.name = 'test';
            att.body = blob.valueOf('Test');
            insert att;
        /*
            WrapperUtils.getDriverGasPrice('CA','ON');
            WrapperUtils.getAllReimbursements(String.valueOf(System.today().Year()),String.valueOf(obj_Driver_list[0].id),obj_Account.id);
            WrapperUtils.getReimbursementsList(obj_Driver_list[0].id,'Approved');
            WrapperUtils.getMileages('November','2019',obj_Driver_list[0].id);
            WrapperUtils.getMileages1('November',String.valueOf(system.today().year()),obj_Driver_list[0].id);
            WrapperUtils.getpastYearReimbursement(obj_Driver_list[0].id);
            WrapperUtils.getLast2Years();
		*/
            WrapperUtils.getReimbursementsListClone(obj_Driver_list[0].id);
            WrapperUtils.approveReimbursements('2019',obj_Driver_list[0].id,obj_Account.id,JSON.serialize(obj_EmployeeReimbursements_list2));
        	WrapperUtils.getUnapprovedReimbursements(obj_admincontact.Id,obj_Account.id,true,'Admin');
        	WrapperUtils.getUnapprovedReimbursements(obj_admincontact.Id,obj_Account.id,false,'Admin');
        	WrapperUtils.getUnapprovedReimbursements(obj_admincontact.Id,obj_Account.id,true,'Manager');
        	WrapperUtils.getUnapprovedReimbursements(obj_admincontact.Id,obj_Account.id,false,'Manager');
        /*
            WrapperUtils.updateLockDate(obj_Account.id,obj_Driver_list[0].id);
            WrapperUtils.readFromFileInchunk('test',att.Name,String.valueOf(att.Id),String.valueOf(obj_Driver_list[0].Id),String.valueOf(obj_Account.Id),null);
    	*/    
	Test.stopTest();   
    }

    public static testmethod void wrapperUtilstestMethod3() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        customSetting.MappingGasStayTime__c = true;
        customSetting.ContactTriggersendEmailForNewContact__c = true;
        customSetting.ContactTriCommunityReimCreate__c = true;
        customSetting.Mileage_Lockdate__c = false;
        insert customSetting;
        
        WrapperUtils obj_WrapperUtils = new WrapperUtils();
        List<IRS_Mileage_Rate__c> obj_IRS_Mileage_Rate =  RecordUtilityClass.insertIrsRate();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;       

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        for(Contact currentContact:obj_Driver_list)
        {
            currentContact.compliancestatus__c='Resubmit Insurance – you submitted an insurance card';
        }
        insert obj_Driver_list;
        
        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;

        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        insert obj_Employee_Reimbursement_list;       
        
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;

        List<Employee_Reimbursement__c> obj_newreimbursements = new List<Employee_Reimbursement__c>();
    for(Contact obj:obj_Driver_list)
        {
            for(integer i=1;i<13;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year()-1);                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year()-1);              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            for(integer i=1;i<=12;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year());                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year());              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            
        }
        insert obj_newreimbursements;
    
        List<Employee_Mileage__c> obj_Employee_Mileage_list1 = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_newreimbursements);
        insert obj_Employee_Mileage_list1;

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List3 = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List3);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();
    

        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list2=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list6=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list6!=null && obj_EmployeeMileages_list6.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list6)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
                    obj_EmployeeMileages_list2.add(obj);
                }
                else
                {
                    i--;
                    obj.isChecked = true;
                    obj_EmployeeMileages_list1.add(obj);
                }
                
            }
        }
    // WrapperUtils.approveMileagesForAdminDash(JSON.serialize(obj_EmployeeMileages_list1),JSON.serialize(obj_EmployeeMileages_list2));
    
        
        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_list_update = new List<Employee_Reimbursement__c>();
        List<string> obj_Employee_Reimbursement_list_update1 = new List<string>();
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            
            obj_Employee_Reimbursement_list_update1.add(obj.id);
        }
        

        EmployeeReimbursements obj_EmployeeReimbursements = WrapperUtils.getEmployeeReimbursements(obj_Employee_Reimbursement_list[0]);
        List<EmployeeReimbursements> obj_EmployeeReimbursements_list2 = new List<EmployeeReimbursements>();
        obj_EmployeeReimbursements_list2.add(obj_EmployeeReimbursements);
        
        
        for(Employee_Reimbursement__c obj:obj_Employee_Reimbursement_list)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        update obj_Employee_Reimbursement_list_update;

        WrapperUtils.getChartData(obj_admincontact.id,obj_admincontact.showTeamRecord__c,obj_Account.id,'Driver');
        WrapperUtils.getComplianceCalculation(obj_Driver_list[0].id,String.valueOf(System.Today().year()));
        List<Contact> obj_updated_Driver_list =  new List<Contact>();
        for(Contact obj_contact:obj_Driver_list)
        {
            obj_contact.Deactivated_Date__c = system.today();
            obj_contact.Last_Pay_Date__c = system.today();
            obj_contact.Driving_States__c='AK;AL;';
            obj_updated_Driver_list.add(obj_contact);
        }
        update obj_updated_Driver_list;

        
        WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');

        obj_admincontact.showTeamRecord__c = true;
        update obj_admincontact;
        Test.startTest();
            WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');
            EmployeeDetails obj_EmployeeDetails = WrapperUtils.getEmployeeDetails(obj_Driver_list[0],110.50,230.50);
            List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
            obj_list_EmployeeDetails1.add(obj_EmployeeDetails);
            
            WrapperUtils.getContact(obj_EmployeeDetails);
            WrapperUtils.getNewContact(obj_EmployeeDetails);
            WrapperUtils.getMonthName('11-2019');
            WrapperUtils.getMonthno('November');
            WrapperUtils.getMonthandYear('November');
            WrapperUtils.getMileagesOfReimbursement(obj_list_mileages[0]);
            WrapperUtils.getLastMonthValue(-1);
        
            WrapperUtils.getPacketandMeetingDetails(obj_Driver_list[0].id);
            List<String> reimbusementidList = new List<String>();
            reimbusementidList.add(obj_Employee_Reimbursement_list_update1[0]);
            WrapperUtils.updateReimbursements(JSON.serialize(reimbusementidList));
            WrapperUtils.updateContactThresholdLimit(JSON.serialize(obj_Employee_Reimbursement_list));
            WrapperUtils.getManager(obj_Driver_list[0].id,obj_admincontact.id);
            WrapperUtils.getadminname(obj_Driver_list[0].id);
            // ManagerDashboard Class Methods
            Attachment att = new Attachment();
            att.parentID = obj_Driver_list[0].Id;
            att.name = 'test';
            att.body = blob.valueOf('Test');
            insert att;
        	
        	WrapperUtils.getLastMonthReimbursements(obj_admincontact.Id,obj_Account.id,true,'Admin/Driver');
        	WrapperUtils.getLastMonthReimbursements(obj_admincontact.Id,obj_Account.id,true,'Manager/Driver');
        	WrapperUtils.getLastMonthReimbursements(obj_admincontact.Id,obj_Account.id,false,'Admin/Driver');
	Test.stopTest();   
    }
    
    public static testmethod void wrapperUtilstestMethod4() {
        TriggerConfig__c customSetting =  new TriggerConfig__c();
        customSetting.Name = 'Defaulttrigger';
        customSetting.MappingGasPriceTrigger__c = true;
        customSetting.MappingGasStayTime__c = true;
        customSetting.ContactTriggersendEmailForNewContact__c = true;
        customSetting.ContactTriCommunityReimCreate__c = true;
        customSetting.Mileage_Lockdate__c = false;
        insert customSetting;
        
        WrapperUtils obj_WrapperUtils = new WrapperUtils();
        List<IRS_Mileage_Rate__c> obj_IRS_Mileage_Rate =  RecordUtilityClass.insertIrsRate();
        RecordUtilityClass.sendEmailforCompliance();
        RecordUtilityClass.enableMappingGasPriceTrigger();
        RecordUtilityClass.vehicleUrlMapping();

        Account obj_Account = RecordUtilityClass.buildAccount();
        insert obj_Account;

        Contact obj_admincontact = RecordUtilityClass.buildAdminContact(obj_Account);
        insert obj_admincontact;       

        List<Contact> obj_Manager_list = RecordUtilityClass.buildManagerContact(obj_Account,obj_admincontact);
        insert obj_Manager_list;

        List<Contact> obj_Driver_list = RecordUtilityClass.buildDriverContact(obj_Account,obj_Manager_list[0]);
        for(Contact currentContact:obj_Driver_list)
        {
            currentContact.compliancestatus__c='Resubmit Insurance – you submitted an insurance card';
        }
        insert obj_Driver_list;
        
        list<Gas_Prices__c> gaslist = RecordUtilityClass.buildGasPrice();
        insert gaslist;

        list<Employee_Reimbursement__c> obj_Employee_Reimbursement_list = RecordUtilityClass.buildPendingEmployee_Reimbursement(obj_Driver_list);
        insert obj_Employee_Reimbursement_list;       
        
        List<Employee_Mileage__c> obj_Employee_Mileage_list = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_Employee_Reimbursement_list);
        insert obj_Employee_Mileage_list;

        List<Employee_Reimbursement__c> obj_newreimbursements = new List<Employee_Reimbursement__c>();
    for(Contact obj:obj_Driver_list)
        {
            for(integer i=1;i<13;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year()-1);                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year()-1);                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year()-1);               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year()-1);              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            for(integer i=1;i<=12;i++)
            {
                Employee_Reimbursement__c obj_Employee_Reimbursement = new Employee_Reimbursement__c();
                if(i<10)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '0'+String.valueOf(i)+'-'+String.valueOf(System.today().year());                               
                }
                else if(i==11)
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'11-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '11-'+String.valueOf(System.today().year());                 
                }
                else
                {
                    obj_Employee_Reimbursement.Name = obj.name+':'+'12-'+String.valueOf(System.today().year());               
                    obj_Employee_Reimbursement.Month__c = '12-'+String.valueOf(System.today().year());              
                }
                obj_Employee_Reimbursement.Contact_Id__c = obj.Id;
                obj_Employee_Reimbursement.Status__c = 'Pending';
                obj_Employee_Reimbursement.Approved_Date__c = null;
                obj_Employee_Reimbursement.IRS_Mileage_Rate__c = obj_IRS_Mileage_Rate[2].id;
                obj_newreimbursements.add(obj_Employee_Reimbursement);
            }
            
        }
        insert obj_newreimbursements;
    
        List<Employee_Mileage__c> obj_Employee_Mileage_list1 = RecordUtilityClass.buildNoApprovedYetEmployeeMileages(obj_newreimbursements);
        insert obj_Employee_Mileage_list1;

        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_List3 = RecordUtilityClass.getEmployee_Reimbursement(obj_Account.id);
        List<EmployeeReimbursementDetailsAdmin> obj_EmployeeReimbursementDetailsAdmin_List = RecordUtilityClass.getListofEmployeeReimbursementDetailsAdmin(obj_Employee_Reimbursement_List3);
        List<Employee_Mileage__c> obj_list_mileages =  RecordUtilityClass.getMileagesList();
    

        List<EmployeeMileages> obj_EmployeeMileages_list1=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list2=new List<EmployeeMileages>();
        List<EmployeeMileages> obj_EmployeeMileages_list6=RecordUtilityClass.getallEmployeeMileages(obj_list_mileages);
        if(obj_EmployeeMileages_list6!=null && obj_EmployeeMileages_list6.size()>0)
        {
            Integer i=0;
            for(EmployeeMileages obj:obj_EmployeeMileages_list6)
            {
                if(i==0)
                {
                    i++;
                    obj.isSelected=true;
                    obj_EmployeeMileages_list2.add(obj);
                }
                else
                {
                    i--;
                    obj.isChecked = true;
                    obj_EmployeeMileages_list1.add(obj);
                }
                
            }
        }
     WrapperUtils.approveMileagesForAdminDash(JSON.serialize(obj_EmployeeMileages_list1),JSON.serialize(obj_EmployeeMileages_list2),JSON.serialize(obj_EmployeeMileages_list1),'Test Name', 'Test@gmail.com');
    
        
        List<Employee_Reimbursement__c> obj_Employee_Reimbursement_list_update = new List<Employee_Reimbursement__c>();
        List<string> obj_Employee_Reimbursement_list_update1 = new List<string>();
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        for(Employee_Reimbursement__c obj:obj_newreimbursements)
        {
            
            obj_Employee_Reimbursement_list_update1.add(obj.id);
        }
        

        EmployeeReimbursements obj_EmployeeReimbursements = WrapperUtils.getEmployeeReimbursements(obj_Employee_Reimbursement_list[0]);
        List<EmployeeReimbursements> obj_EmployeeReimbursements_list2 = new List<EmployeeReimbursements>();
        obj_EmployeeReimbursements_list2.add(obj_EmployeeReimbursements);
        
        
        for(Employee_Reimbursement__c obj:obj_Employee_Reimbursement_list)
        {
            obj.Approved_Date__c = system.today();
            obj.Status__c = 'Approved';
            obj_Employee_Reimbursement_list_update.add(obj);
        }
        update obj_Employee_Reimbursement_list_update;

        WrapperUtils.getChartData(obj_admincontact.id,obj_admincontact.showTeamRecord__c,obj_Account.id,'Driver');
        WrapperUtils.getComplianceCalculation(obj_Driver_list[0].id,String.valueOf(System.Today().year()));
        List<Contact> obj_updated_Driver_list =  new List<Contact>();
        for(Contact obj_contact:obj_Driver_list)
        {
            obj_contact.Deactivated_Date__c = system.today();
            obj_contact.Last_Pay_Date__c = system.today();
            obj_contact.Driving_States__c='AK;AL;';
            obj_updated_Driver_list.add(obj_contact);
        }
        update obj_updated_Driver_list;

        
        WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');

        obj_admincontact.showTeamRecord__c = true;
        update obj_admincontact;
        Test.startTest();
            WrapperUtils.getChartData(obj_admincontact.id,false,obj_Account.id,'Driver');
            EmployeeDetails obj_EmployeeDetails = WrapperUtils.getEmployeeDetails(obj_Driver_list[0],110.50,230.50);
            List<EmployeeDetails> obj_list_EmployeeDetails1 = new List<EmployeeDetails>();
            obj_list_EmployeeDetails1.add(obj_EmployeeDetails);
            
            WrapperUtils.getContact(obj_EmployeeDetails);
            WrapperUtils.getNewContact(obj_EmployeeDetails);
            WrapperUtils.getMonthName('11-2019');
            WrapperUtils.getMonthno('November');
            WrapperUtils.getMonthandYear('November');
            WrapperUtils.getMileagesOfReimbursement(obj_list_mileages[0]);
            WrapperUtils.getLastMonthValue(-1);
        
            WrapperUtils.getPacketandMeetingDetails(obj_Driver_list[0].id);
            List<String> reimbusementidList = new List<String>();
            reimbusementidList.add(obj_Employee_Reimbursement_list_update1[0]);
            WrapperUtils.updateReimbursements(JSON.serialize(reimbusementidList));
            WrapperUtils.updateContactThresholdLimit(JSON.serialize(obj_Employee_Reimbursement_list));
            WrapperUtils.getManager(obj_Driver_list[0].id,obj_admincontact.id);
            WrapperUtils.getadminname(obj_Driver_list[0].id);
            // ManagerDashboard Class Methods
            Attachment att = new Attachment();
            att.parentID = obj_Driver_list[0].Id;
            att.name = 'test';
            att.body = blob.valueOf('Test');
            insert att;
       	String json = '{\"variablerate\":\"0.0000\",\"variableamount\":\"147.1300\",\"tripdate\":\"06/22/21\",\"tracingstyle\":\"\",\"totaltime\":\"00:00\",\"totalrejected\":\"0.00\",\"totalpending\":\"0.00\",\"totalMonthlyApproveVariable\":null,\"totalMileages\":\"1675.00\",\"tag\":null,\"submitteddate\":\"07/07/21\",\"staytime\":\"00:00\",\"status\":\"Approved\",\"starttime\":\"\",\"reimbursementid\":\"a003r00000k97nPAAQ\",\"originname\":\"Federal\",\"origin\":\"Delhi\",\"notes\":null,\"month\":\"06-2021\",\"mileage\":\"12.00\",\"maintTyre\":\"12.0000\",\"lockdate\":null,\"isUnapprove\":false,\"isSelected\":false,\"isLockDate\":false,\"isChecked\":true,\"id\":\"a0B3r000012fdA8EAI\",\"fuelRate\":\"3.13\",\"endtime\":\"\",\"emailaddress\":\"johnson@gmail.com\",\"drivingtime\":\"00:00\",\"driverid\":\"0033r00003d3dorAAA\",\"destinationname\":\"Serenity\",\"destination\":\"Mumbai\",\"dayofweek\":\"\",\"approveddate\":\"07/30/21\",\"$$hashKey\":\"object:174\"}';
        	WrapperUtils.getLastMonthReimbursements(obj_admincontact.Id,obj_Account.id,false,'Manager/Driver');
        	//WrapperUtils.approveMileagesForAdminDash(json,json,json,obj_admincontact.Name,obj_admincontact.External_Email__c);
        	//WrapperUtils.getUnapprovedMileages(obj_Employee_Reimbursement_list[0].Id);
        	//WrapperUtils.approveMileagesClone1();
        	
	Test.stopTest();   
    }   
}