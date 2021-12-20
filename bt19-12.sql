create database BTVN_quanlydiemsinhvien;

create table sinhvien(
masv int primary key auto_increment,
hoten varchar(20),
gioitinh varchar(20),
ngaysinh date,
malop int,
foreign key (malop) references lop (malop),
hocbong varchar(20),
tinh varchar(20)

);

create table lop(
malop int primary key auto_increment,
tenlop varchar(20),
makhoa int,
foreign key (makhoa) references khoa (makhoa)
);

create table khoa(
makhoa int primary key auto_increment,
tenkhoa varchar(20),
socbgd int
);


create table monhoc(
maMH int primary key auto_increment,
tenMH varchar(20),
sotiet int
);

create table ketqua(
masv int,
mamh int,
diemthi int,
primary key(masv, mamh),
foreign key (masv) references sinhvien(masv),
foreign key (mamh) references monhoc(mamh)
);

-- Câu 1: Liệt kê danh sách các lớp của khoa, thông tin cần Malop, TenLop, MaKhoa

select malop, tenlop, makhoa
from lop;

-- Câu 2: Lập danh sách sinh viên gồm: MaSV, HoTen, HocBong

select masv, hoten , hocbong
from sinhvien;

-- Câu 3: Lập danh sách sinh viên có học bổng. Danh sách cần MaSV, Nu, HocBong

select masv, gioitinh, hocbong
from sinhvien
where hocbong is null;

-- Câu 5: Lập danh sách sinh viên có họ ‘Trần’
select * 
from sinhvien
where hoten like 'Trần%';

-- Câu 6: Lập danh sách sinh viên nữ có học bổng
select * 
from sinhvien
where hocbong is not null and gioitinh = 'Nữ';

-- Câu 7: Lập danh sách sinh viên nữ hoặc danh sách sinh viên có học bổng
select * 
from sinhvien
where hocbong is not null;

-- Câu 8: Lập danh sách sinh viên có năm sinh từ 1978 đến 1985. Danh sách cần các thuộc tính của quan hệ SinhVien
select *
from ketqua join sinhvien on ketqua.masv = sinhvien.masv
			join lop on sinhvien.malop = lop.malop
            WHERE sinhvien.ngaysinh BETWEEN '1978-1-1' AND '1985-12-31';
            
-- Câu 9: Liệt kê danh sách sinh viên được sắp xếp tăng dần theo MaSV
select *
from ketqua join sinhvien on ketqua.masv = sinhvien.masv
			join lop on sinhvien.malop = lop.malop
            order by sinhvien.masv;
-- Câu 10: Liệt kê danh sách sinh viên được sắp xếp giảm dần theo HocBong
select *
from ketqua join sinhvien on ketqua.masv = sinhvien.masv
			join lop on sinhvien.malop = lop.malop
            order by sinhvien.hocbong;
            
-- Ví du 12: Lập danh sách sinh viên có học bổng của khoa K63. Thông tin cần: MaSV
select masv , hoten, hocbong,tenkhoa 
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.malop = khoa.makhoa
              where sinhvien.hocbong is not null and khoa.tenkhoa = 'K63';
              
-- Câu 14: Cho biết số sinh viên của mỗi lớp
select tenlop, count(sinhvien.malop) as soluonghv
from sinhvien join lop on sinhvien.malop = lop.malop
group by tenlop;

-- Câu 15: Cho biết số lượng sinh viên của mỗi khoa.
select tenkhoa, count(lop.makhoa) as soluonghvcuakhoa
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.makhoa = khoa.makhoa
              group by tenkhoa;
-- Câu 16: Cho biết số lượng sinh viên nữ của mỗi khoa.
select tenkhoa , count(sinhvien.gioitinh) as soluonghvNu
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.malop = khoa.makhoa
              where sinhvien.gioitinh = 'Nữ'
              group by tenkhoa
			;
-- Câu 17: Cho biết tổng tiền học bổng của mỗi lớp
select tenlop, sum(sinhvien.hocbong)
from sinhvien join lop on sinhvien.malop = lop.malop
group by tenlop;

-- Câu 18: Cho biết tổng số tiền học bổng của mỗi khoa
select tenkhoa, sum(sinhvien.hocbong)
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.malop = khoa.makhoa
              group by tenkhoa;
              
-- Câu 19: Lập danh sánh những khoa có nhiều hơn 2 sinh viên. Danh sách cần: MaKhoa, TenKhoa, Soluong 
select khoa.makhoa, khoa.tenkhoa, count(lop.tenlop) as soluong
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.makhoa = khoa.makhoa
              group by tenkhoa
              having soluong >= 2;

-- Câu 20: Lập danh sánh những khoa có nhiều hơn 2 sinh viên nữ. Danh sách cần: MaKhoa, TenKhoa, Soluong
select khoa.makhoa, tenkhoa , count(sinhvien.gioitinh) as soluonghvNu
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.malop = khoa.makhoa
              where sinhvien.gioitinh = 'Nữ'
              group by tenkhoa
              having soluonghvNu >=2;  

 -- Câu22: Lập danh sách sinh viên có học bổng cao nhất             

select sinhvien.*
from sinhvien
having sinhvien.hocbong = (select max(sinhvien.hocbong)
from sinhvien);

-- Câu 23: Lập danh sách sinh viên có điểm thi môn Toán cao nhất
create view diemthiToan as
select hoten, diemthi, tenmh
from sinhvien join ketqua on sinhvien.masv = ketqua.masv
			join monhoc on ketqua.mamh = monhoc.maMH
            where tenMH = 'Toán';
            


select sinhvien.hoten, ketqua.diemthi, monhoc.tenmh
from sinhvien join ketqua on sinhvien.masv = ketqua.masv
			join monhoc on ketqua.mamh = monhoc.maMH
            where ketqua.diemthi = (select max(diemthi) from diemthiToan) and monhoc.tenMH = 'Toán';

-- Câu 25: Cho biết những khoa nào có nhiều sinh viên nhất
create view soluongsvkhoa as
select tenkhoa, count(tenkhoa) as soluongsv
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.makhoa = khoa.makhoa
              group by tenkhoa;
              

select tenkhoa, count(tenkhoa) as soluongsv
from sinhvien join lop on sinhvien.malop = lop.malop
			  join khoa on lop.makhoa = khoa.makhoa
				group by tenkhoa
                having  soluongsv = (select max(soluongsv)from soluongsvkhoa);
             
