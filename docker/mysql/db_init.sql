CREATE TABLE IF NOT EXISTS basic_table (
    id INT NOT NULL AUTO_INCREMENT,
    descrip VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

insert into basic_table (descrip) 
    values ('one value'),('another value');