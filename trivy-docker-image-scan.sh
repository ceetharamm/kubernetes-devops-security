dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerImageName

docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName

# Trivy Scan result processing
exit_code=$?
echo "Exit Code : #exit_code"

# check scan result
if [[ "$(exit_code)" ==1 ]]; then
  echo "Image Scaning failed. Vulnerabilities found"
  exit 1;
else
  echo "Image Scaning passed"
fi;
