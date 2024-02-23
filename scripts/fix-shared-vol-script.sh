if [ -z "$BOSH_DEPLOYMENT" ]; then
    echo "Error: Please set env variable BOSH_DEPLOYMENT to the name of the deployment where Portworx's worker nodes are" >&2
    exit 1
fi

for wnode in $(bosh vms -d $BOSH_DEPLOYMENT | grep worker| awk '{print $1}')
do
	# Let's list the contents of the bin folder for our portworx job
	bosh ssh -d ${BOSH_DEPLOYMENT} $wnode sudo "ls -l /var/vcap/jobs/stop-portworx-service/bin/"
	bosh -d ${BOSH_DEPLOYMENT} scp ../jobs/stop-portworx-service/templates/pre-stop.erb ${wnode}:/tmp/pre-stop
	# kubelet job expects that we drain shared volumes as part of pre-stop step
	bosh ssh -d ${BOSH_DEPLOYMENT} $wnode sudo "mv /tmp/pre-stop  /var/vcap/jobs/stop-portworx-service/bin/"
	# With the pre-stop script in place, we don't need the drain script
	bosh ssh -d ${BOSH_DEPLOYMENT} $wnode sudo rm /var/vcap/jobs/stop-portworx-service/bin/drain
	bosh ssh -d ${BOSH_DEPLOYMENT} $wnode sudo "ls -l /var/vcap/jobs/stop-portworx-service/bin/"
done
