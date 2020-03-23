sfdx force:org:create -f config/project-scratch-def.json -d 1 -s -w 60
#Add perm set to source code
sfdx shane:permset:create -n ATIS_Admin -o ATIS__c
#push source code into scratch org
sfdx force:source:push
sfdx force:user:password:generate
sfdx force:user:permset:assign --permsetname ATIS_Admin
sfdx force:data:bulk:upsert -s ATIS__c -f data/ATIS-bulk-load.csv -i Ext_Id__c

#install EVL Playgound Package (version 1.22) & Einstein Language Intent Accuracy Package
sfdx force:package:install -p 04t0b000001oXjv --noprompt
sfdx force:package:install -p 04t4J000002AU1H --noprompt

#Create Heroku App 
sfdx shane:heroku:repo:deploy -g mshanemc -r heroku-empty -n `basename "${PWD/mshanemc-}" | awk -F'-' '{print "medical-appt-" $3}'` -t autodeployed-demos
# Attach free Einstein Vision and Language add-on + Configure the Playground
sfdx shane:ai:playground:setupHeroku --verbose -a `basename "${PWD/mshanemc-}" | awk -F'-' '{print "medical-appt-" $3}'` -k 

#Upload ATIS dataset and train an intent classification model on it
sfdx shane:ai:dataset:upload -f data/ATIS-intent-training.csv -n AtisDataset --train

#open the scratch org
sfdx force:org:open -p /lightning/setup/SetupOneHome/home





