###############################################################################
# bastion
###############################################################################

resource "aws_instance" "bastion" {

  ami                          =  var.bastianami
  instance_type                =  var.type
  subnet_id                    =  aws_subnet.public1.id
  vpc_security_group_ids       =  [ aws_security_group.bastion.id]
  key_name                     =  aws_key_pair.key.id
  tags = {
    Name = "${var.project}-bastion"
    Project = var.project
  }

}


###############################################################################
# webserver
###############################################################################

resource "aws_instance" "webserver" {

  ami                          =  var.webami
  instance_type                =  var.type
  subnet_id                    =  aws_subnet.public1.id
  vpc_security_group_ids       =  [ aws_security_group.webserver.id]
  key_name                     =  aws_key_pair.key.id
  tags = {
    Name = "${var.project}-webserver"
    Project = var.project
  }
  
}

###############################################################################
# database
###############################################################################

resource "aws_instance" "database" {

  ami                          =  var.dbami
  instance_type                =  var.type
  subnet_id                    =  aws_subnet.private1.id
  vpc_security_group_ids       =  [ aws_security_group.database.id]
  key_name                     =  aws_key_pair.key.id
  tags = {
    Name = "${var.project}-database"
    Project = var.project
  }
  
}
