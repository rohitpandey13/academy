The venues id and names are taken from the following dataset.

gowalla-dataset.zip
from https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/locrec/gowalla-dataset.zip
The project is being developed in the context of the SInteliGIS project financed by the Portuguese Foundation for Science and Technology (FCT) through project grant PTDC/EIA-EIA/109840/2009. 
--

The checkins are available in the following dataset
loc-gowalla_totalCheckins.txt.gz
from https://snap.stanford.edu/data/loc-gowalla.html

E. Cho, S. A. Myers, J. Leskovec. Friendship and Mobility: Friendship and Mobility: User Movement in Location-Based Social Networks ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (KDD), 2011.


About the files in this directory:

The files loc-gowalla_totalCheckins.txt and spots.txt are samples extracted from the above mentioned datasets.
The files checkins.csv and venues.csv are generated from the given data sources. In order to regenerate this files download the datasets as provided above and execute the python notebook lbsn.ipynb

wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/locrec/gowalla-dataset.zip
unzip gowalla-dataset.zip
perl -pe 's/POINT\((\-?\d+\.\d+)\s+(\-?\d+\.\d+)\)/$2\t$1/g' ./gowalla-dataset/spots.txt > ./loc-gowalla_venues.csv

wget https://snap.stanford.edu/data/loc-gowalla_totalCheckins.txt.gz
gunzip -f loc-gowalla_totalCheckins.txt.gz
sed -e 's/Z/+0000/' -e ’s/T/ /' loc-gowalla_totalCheckins.txt > loc-gowalla_events.csv
rm loc-gowalla_totalCheckins.txt

wget https://snap.stanford.edu/data/loc-gowalla_edges.txt.gz
gunzip -f loc-gowalla_edges.txt.gz
mv loc-gowalla_edges.txt loc-gowalla_users.csv
