create table HANGHOA (
    MAHANG int not null primary key,
	TENHANG varchar(50) ,
	SOLUONG int,
	GIAMUA float,
	GIABAN float
)
create table HOADON (
	MAHOADON int primary key,
	MAHANG int not null,
	TONGTIEN float,
	NGAYLAPHD date,
	MANHANVIEN int not null ,
	CONSTRAINT fk_hh_mh
  FOREIGN KEY (MAHANG)
  REFERENCES HANGHOA (MAHANG),
	CONSTRAINT fk_hh_mnv
  FOREIGN KEY (MANHANVIEN)
  REFERENCES NHANVIEN (MANHANVIEN)
)
create table NHANVIEN( 
	MANHANVIEN int primary key,
	TENNHANVIEN varchar(50),
	DIACHI varchar(80),
	SDT varchar (20)
)
