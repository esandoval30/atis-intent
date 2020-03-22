sfdx force:org:create -f config/project-scratch-def.json -d 1 -s -w 60
#Add perm set to source code
sfdx shane:permset:create -n ATIS_Admin -o ATIS__c
#push source code into scratch org
sfdx force:source:push
sfdx force:user:password:generate
sfdx force:user:permset:assign --permsetname ATIS_Admin
#Bulk ATIS utterance data
sfdx force:data:bulk:upsert -s ATIS__c -f data/ATIS-bulk-load.csv -i Ext_Id__c
#install EVL Playgound Package (version 1.22) & 
sfdx force:package:install -p 04t0b000001oXjv 
#Install Einstein Language Intent Accuracy Package
#sfdx force:package:install -p ???

#Provision EVL account & Configure the Playground
#sfdx shane:heroku:repo:deploy -g mshanemc -r heroku-empty -n atis-intent -t autodeployed-demos
sfdx shane:heroku:repo:deploy -g mshanemc -r heroku-empty -n `basename "${PWD/mshanemc-}" | awk -F'-' '{print "medical-appt-" $3}'` -t autodeployed-demos
sfdx shane:ai:playground:setupHeroku --verbose -a `basename "${PWD/mshanemc-}" | awk -F'-' '{print "medical-appt-" $3}'` -k 
#sfdx shane:ai:dataset:upload -f data/ATIS-intent-training.csv -n AtisDataset --train

#open the scratch org
sfdx force:org:open -p /lightning/setup/SetupOneHome/home





