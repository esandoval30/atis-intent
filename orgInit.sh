sfdx force:org:create -f config/project-scratch-def.json -d 1 -s -w 60
#Add perm set to source code
sfdx shane:permset:create -n ATIS_Admin -o ATIS__c
#push source code into scratch org
sfdx force:source:push
#create user
sfdx force:user:password:generate
#assign permset to user
sfdx force:user:permset:assign --permsetname ATIS_Admin
#Bulk ATIS utterance data
sfdx force:data:bulk:upsert -s ATIS__c -f data/ATIS-bulk-load.csv -i Ext_Id__c
#open the scratch org
sfdx force:org:open -p /lightning/setup/SetupOneHome/home

#Provision EVL account
#sfdx shane:heroku:repo:deploy -g mshanemc -r heroku-empty -n atis-intent -t autodeployed-demos

#install EVL Playgound Package (version 1.22)
#sfdx force:package:install -p 04t0b000001oXjv 

#Configure Playground
#sfdx shane:ai:playground:setupHeroku --verbose -a atis-intent -k

#Install Einstein Language Intent Accuracy Package
#sfdx force:package:install -p ???