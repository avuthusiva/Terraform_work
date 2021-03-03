terraform {
    backend "s3" {
        region = "us-east-1"
        bucket = "sivaavuthu"
        key = "dev/configuration_Micro.tfstate"
    }
}
