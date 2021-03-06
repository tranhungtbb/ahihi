USE [master]
GO
/****** Object:  Database [QLPT]    Script Date: 5/29/2019 9:04:39 AM ******/
CREATE DATABASE [QLPT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QLPT', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\QLPT.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'QLPT_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\DATA\QLPT_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [QLPT] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QLPT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QLPT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QLPT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QLPT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QLPT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QLPT] SET ARITHABORT OFF 
GO
ALTER DATABASE [QLPT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [QLPT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QLPT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QLPT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QLPT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QLPT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QLPT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QLPT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QLPT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QLPT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [QLPT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QLPT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QLPT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QLPT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QLPT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QLPT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QLPT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QLPT] SET RECOVERY FULL 
GO
ALTER DATABASE [QLPT] SET  MULTI_USER 
GO
ALTER DATABASE [QLPT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QLPT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QLPT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QLPT] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [QLPT] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [QLPT] SET QUERY_STORE = OFF
GO
USE [QLPT]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [QLPT]
GO
/****** Object:  UserDefinedFunction [dbo].[KtraNgayLapThuocThang]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[KtraNgayLapThuocThang](@ngayLap datetime, @thang int) returns int
as
begin 
	declare @kt int =0
	if Cast(Year(@ngayLap) as int) = Cast(Year(CURRENT_TIMESTAMP) as int) and Cast(Month(@ngayLap) as int) = @thang
	     select @kt = 1
	return @kt
end
GO
/****** Object:  UserDefinedFunction [dbo].[SoLuongNguoiTrongPhong]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[SoLuongNguoiTrongPhong](@maphong varchar(20)) returns int
as
begin
	declare @sl  int =0
	select @sl = count(kh.MaKhachHang)
	from KhachHang kh
	where kh.MaPhong = @maphong
	return @sl
end
GO
/****** Object:  UserDefinedFunction [dbo].[SoNgayConLaiCuaHopDong]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[SoNgayConLaiCuaHopDong](@ma int) returns int
as
begin
	declare @count int =0
	select @count = DATEDIFF(day,CURRENT_TIMESTAMP,dateadd(month,hd.ThoiGianThue,hd.NgayBatDau))
	from HopDong hd
	where hd.MaHopDong = @ma
	return @count
end
GO
/****** Object:  UserDefinedFunction [dbo].[TongDVDienNuoc]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[TongDVDienNuoc](@mahd int, @thang int) returns int
as
begin
	declare @tong int =0
	select @tong = sum((ct.ChiSoMoi-ct.ChiSoCu)*dv.DonGia)
	from ChiTietDienNuoc ct, DichVu dv, HoaDon hd
	where hd.MaHoaDon = ct.MaHoaDon and ct.MaDichVu = dv.MaDichVu
	and hd.MaHoaDon = @mahd and dbo.[KtraNgayLapThuocThang](hd.NgayLap,@thang)=1
	return @tong
end
GO
/****** Object:  UserDefinedFunction [dbo].[TongDVKhac]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[TongDVKhac](@mahd int, @thang int) returns int
as
begin
	declare @tong int =0
	select @tong = sum(SoLuong*dv.DonGia)
	from ChiTietHoaDon ct, DichVu dv, HoaDon hd
	where hd.MaHoaDon = ct.MaHoaDon and ct.MaDichVu = dv.MaDichVu
	and hd.MaHoaDon = @mahd and dbo.[KtraNgayLapThuocThang](hd.NgayLap,@thang)=1
	return @tong
end
GO
/****** Object:  Table [dbo].[ChiTietDienNuoc]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietDienNuoc](
	[MaDichVu] [int] NOT NULL,
	[MaHoaDon] [int] NOT NULL,
	[ChiSoCu] [int] NULL,
	[ChiSoMoi] [int] NULL,
 CONSTRAINT [PK_ChiTietDienNuoc] PRIMARY KEY CLUSTERED 
(
	[MaDichVu] ASC,
	[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChiTietHoaDon]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChiTietHoaDon](
	[MaDichVu] [int] NOT NULL,
	[MaHoaDon] [int] NOT NULL,
	[SoLuong] [int] NULL,
 CONSTRAINT [PK_ChiTietHoaDon] PRIMARY KEY CLUSTERED 
(
	[MaDichVu] ASC,
	[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DichVu]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DichVu](
	[MaDichVu] [int] NOT NULL,
	[TenDichVu] [nvarchar](100) NULL,
	[DonGia] [int] NULL,
	[DVT] [nvarchar](30) NULL,
 CONSTRAINT [PK_DichVu] PRIMARY KEY CLUSTERED 
(
	[MaDichVu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HoaDon]    Script Date: 5/29/2019 9:04:40 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HoaDon](
	[MaHoaDon] [int] IDENTITY(1,1) NOT NULL,
	[NgayLap] [date] NULL,
	[MaKhachHang] [int] NULL,
 CONSTRAINT [PK_HoaDon] PRIMARY KEY CLUSTERED 
(
	[MaHoaDon] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HopDong]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HopDong](
	[MaHopDong] [int] NOT NULL,
	[NgayBatDau] [date] NULL,
	[ThoiGianThue] [int] NULL,
	[TienCoc] [int] NULL,
	[GhiChu] [nvarchar](150) NULL,
	[MaPhong] [varchar](10) NULL,
	[MaKhachHang] [int] NULL,
 CONSTRAINT [PK_HopDong] PRIMARY KEY CLUSTERED 
(
	[MaHopDong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[KhachHang]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KhachHang](
	[MaKhachHang] [int] NOT NULL,
	[HoTen] [nvarchar](100) NULL,
	[NgaySinh] [date] NULL,
	[GioiTinh] [nvarchar](20) NULL,
	[QueQuan] [nvarchar](150) NULL,
	[SDT] [int] NULL,
	[CMND] [int] NULL,
	[Status] [bit] NULL,
	[MaPhong] [varchar](10) NULL,
 CONSTRAINT [PK_KhachHang] PRIMARY KEY CLUSTERED 
(
	[MaKhachHang] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LoaiPhong]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiPhong](
	[MaLoaiPhong] [int] NOT NULL,
	[TenLoaiPhong] [nvarchar](50) NULL,
	[DienTich] [int] NULL,
	[MoTa] [nvarchar](100) NULL,
	[DonGia] [int] NULL,
	[SoLuongToiDa] [int] NULL,
 CONSTRAINT [PK_LoaiPhong] PRIMARY KEY CLUSTERED 
(
	[MaLoaiPhong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phong]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phong](
	[MaPhong] [varchar](10) NOT NULL,
	[TenPhong] [nvarchar](50) NULL,
	[GhiChu] [nvarchar](150) NULL,
	[MaLoaiPhong] [int] NULL,
 CONSTRAINT [PK_Phong] PRIMARY KEY CLUSTERED 
(
	[MaPhong] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[MaTaiKhoan] [int] IDENTITY(1,1) NOT NULL,
	[TenNguoiDung] [nvarchar](150) NULL,
	[TenDangNhap] [varchar](50) NULL,
	[MatKhau] [varchar](50) NULL,
 CONSTRAINT [PK_TaiKhoan] PRIMARY KEY CLUSTERED 
(
	[MaTaiKhoan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThietBi]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThietBi](
	[MaThietBi] [int] NOT NULL,
	[TenThietBi] [nvarchar](100) NULL,
	[TinhTrang] [nvarchar](20) NULL,
	[GhiChu] [nvarchar](150) NULL,
 CONSTRAINT [PK_ThietBi] PRIMARY KEY CLUSTERED 
(
	[MaThietBi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrangBi]    Script Date: 5/29/2019 9:04:41 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrangBi](
	[MaPhong] [varchar](10) NOT NULL,
	[MaThietBi] [int] NOT NULL,
	[SoLuong] [int] NULL,
 CONSTRAINT [PK_TrangBi] PRIMARY KEY CLUSTERED 
(
	[MaPhong] ASC,
	[MaThietBi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[ChiTietDienNuoc] ([MaDichVu], [MaHoaDon], [ChiSoCu], [ChiSoMoi]) VALUES (1, 6, 2, 54)
INSERT [dbo].[ChiTietDienNuoc] ([MaDichVu], [MaHoaDon], [ChiSoCu], [ChiSoMoi]) VALUES (2, 1, 1, 20)
INSERT [dbo].[ChiTietDienNuoc] ([MaDichVu], [MaHoaDon], [ChiSoCu], [ChiSoMoi]) VALUES (2, 5, 4, 6)
INSERT [dbo].[ChiTietHoaDon] ([MaDichVu], [MaHoaDon], [SoLuong]) VALUES (1, 1, 2)
INSERT [dbo].[ChiTietHoaDon] ([MaDichVu], [MaHoaDon], [SoLuong]) VALUES (3, 1, 2)
INSERT [dbo].[ChiTietHoaDon] ([MaDichVu], [MaHoaDon], [SoLuong]) VALUES (3, 5, 2)
INSERT [dbo].[DichVu] ([MaDichVu], [TenDichVu], [DonGia], [DVT]) VALUES (1, N'Điện', 4000, N'Số')
INSERT [dbo].[DichVu] ([MaDichVu], [TenDichVu], [DonGia], [DVT]) VALUES (2, N'Nước', 20000, N'Khối')
INSERT [dbo].[DichVu] ([MaDichVu], [TenDichVu], [DonGia], [DVT]) VALUES (3, N'Mạng', 100000, N'Người/Tháng')
SET IDENTITY_INSERT [dbo].[HoaDon] ON 

INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayLap], [MaKhachHang]) VALUES (1, CAST(N'2019-05-28' AS Date), 1)
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayLap], [MaKhachHang]) VALUES (5, CAST(N'2019-05-28' AS Date), 4)
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayLap], [MaKhachHang]) VALUES (6, CAST(N'2019-05-14' AS Date), 6)
INSERT [dbo].[HoaDon] ([MaHoaDon], [NgayLap], [MaKhachHang]) VALUES (7, CAST(N'2019-05-28' AS Date), 10)
SET IDENTITY_INSERT [dbo].[HoaDon] OFF
INSERT [dbo].[HopDong] ([MaHopDong], [NgayBatDau], [ThoiGianThue], [TienCoc], [GhiChu], [MaPhong], [MaKhachHang]) VALUES (1, CAST(N'2019-04-27' AS Date), 1, 12, N'', N'P1', 1)
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (1, N'Trần Đình Hùng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P1')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (2, N'Trần Đình Quang', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P1')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (3, N'Trần Văn Huy', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P1')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (4, N'Lê Đình Dần', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P2')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (5, N'Trần Như Ngọc', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P2')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (6, N'Trần Thị Thùy Linh', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P3')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (7, N'Trần Hùng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P3')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (8, N'Trần Quang Lê', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P3')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (9, N'Thùy Chi', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P5')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (10, N'Chi PuPu', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P7')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (11, N'Trần Lê Hoàng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P7')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (12, N'Lê Văn Huy', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P8')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (13, N'Trần Quang An', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P8')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (14, N'Trần Đình Hùng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P8')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (15, N'Trần Đình Hùng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P8')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (16, N'Trần Đình A', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 1, N'P9')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (17, N'Trần Đình B', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P9')
INSERT [dbo].[KhachHang] ([MaKhachHang], [HoTen], [NgaySinh], [GioiTinh], [QueQuan], [SDT], [CMND], [Status], [MaPhong]) VALUES (18, N'Trần Đình Hùng', CAST(N'1998-11-03' AS Date), N'Nam', N'Thái Bình', 329920066, 16150323, 0, N'P9')
INSERT [dbo].[LoaiPhong] ([MaLoaiPhong], [TenLoaiPhong], [DienTich], [MoTa], [DonGia], [SoLuongToiDa]) VALUES (1, N'Phòng loại A', 35, N'Phòng rộng rãi ,khép kíp, có gác xép,có ban công,nhiều cửa sổ, nóng lạnh điều hòa đầy đủ', 2500000, 4)
INSERT [dbo].[LoaiPhong] ([MaLoaiPhong], [TenLoaiPhong], [DienTich], [MoTa], [DonGia], [SoLuongToiDa]) VALUES (2, N'Phòng loại B', 30, N'Phòng rộng rãi , khép kíp, có gác xép,có ban công thoáng mát,nóng lạnh điều hòa đầy đủ', 2000000, 3)
INSERT [dbo].[LoaiPhong] ([MaLoaiPhong], [TenLoaiPhong], [DienTich], [MoTa], [DonGia], [SoLuongToiDa]) VALUES (3, N'Phòng loại C', 25, N'Phòng rộng rãi , khép kíp, có gác xép, nóng lạnh điều hòa đầy đủ', 1700000, 3)
INSERT [dbo].[LoaiPhong] ([MaLoaiPhong], [TenLoaiPhong], [DienTich], [MoTa], [DonGia], [SoLuongToiDa]) VALUES (4, N'Phòng loại D', 20, N'Phòng rộng rãi , khép kíp, không có gác xép', 1500000, 2)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P1', N'D1 101', N'Nhà D1 tầng 1 phòng số 1', 1)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P10', N'D1 303', N'Nhà D1 tầng 3 phòng số 3', 1)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P2', N'D1 102', N'Nhà D1 tầng 1 phòng số 2', 3)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P3', N'D1 103', N'Nhà D1 tầng 1 phòng số 3', 2)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P4', N'D1 104', N'Nhà D1 tầng 1 phòng số 4', 3)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P5', N'D1 201', N'Nhà D1 tầng 2 phòng số 1', 1)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P6', N'D1 202', N'Nhà D1 tầng 2 phòng số 2', 1)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P7', N'D1 203', N'Nhà D1 tầng 2 phòng số 3', 2)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P8', N'D1 301', N'Nhà D1 tầng 3 phòng số 1', 4)
INSERT [dbo].[Phong] ([MaPhong], [TenPhong], [GhiChu], [MaLoaiPhong]) VALUES (N'P9', N'D1 302', N'Nhà D1 tầng 3 phòng số 2', 4)
SET IDENTITY_INSERT [dbo].[TaiKhoan] ON 

INSERT [dbo].[TaiKhoan] ([MaTaiKhoan], [TenNguoiDung], [TenDangNhap], [MatKhau]) VALUES (1, N'Trần Đình Hùng', N'tranhungtbb', N'Hung11031998123')
SET IDENTITY_INSERT [dbo].[TaiKhoan] OFF
INSERT [dbo].[ThietBi] ([MaThietBi], [TenThietBi], [TinhTrang], [GhiChu]) VALUES (3, N'Bình nóng lạnh', N'', N'')
INSERT [dbo].[ThietBi] ([MaThietBi], [TenThietBi], [TinhTrang], [GhiChu]) VALUES (4, N'Gường đôi', N'', N'')
INSERT [dbo].[ThietBi] ([MaThietBi], [TenThietBi], [TinhTrang], [GhiChu]) VALUES (7, N'Salon', N'', N'')
INSERT [dbo].[ThietBi] ([MaThietBi], [TenThietBi], [TinhTrang], [GhiChu]) VALUES (8, N'Ghế', N'', N'')
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P1', 3, 1)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P1', 4, 1)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P1', 8, 4)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P2', 3, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P2', 4, 1)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P3', 3, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P4', 4, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P5', 4, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P6', 4, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P7', 4, 0)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P7', 8, 2)
INSERT [dbo].[TrangBi] ([MaPhong], [MaThietBi], [SoLuong]) VALUES (N'P9', 4, 0)
ALTER TABLE [dbo].[ChiTietDienNuoc]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDienNuoc_DichVu] FOREIGN KEY([MaDichVu])
REFERENCES [dbo].[DichVu] ([MaDichVu])
GO
ALTER TABLE [dbo].[ChiTietDienNuoc] CHECK CONSTRAINT [FK_ChiTietDienNuoc_DichVu]
GO
ALTER TABLE [dbo].[ChiTietDienNuoc]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietDienNuoc_HoaDon] FOREIGN KEY([MaHoaDon])
REFERENCES [dbo].[HoaDon] ([MaHoaDon])
GO
ALTER TABLE [dbo].[ChiTietDienNuoc] CHECK CONSTRAINT [FK_ChiTietDienNuoc_HoaDon]
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_DichVu] FOREIGN KEY([MaDichVu])
REFERENCES [dbo].[DichVu] ([MaDichVu])
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_DichVu]
GO
ALTER TABLE [dbo].[ChiTietHoaDon]  WITH CHECK ADD  CONSTRAINT [FK_ChiTietHoaDon_HoaDon] FOREIGN KEY([MaHoaDon])
REFERENCES [dbo].[HoaDon] ([MaHoaDon])
GO
ALTER TABLE [dbo].[ChiTietHoaDon] CHECK CONSTRAINT [FK_ChiTietHoaDon_HoaDon]
GO
ALTER TABLE [dbo].[HoaDon]  WITH CHECK ADD  CONSTRAINT [FK_HoaDon_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[KhachHang] ([MaKhachHang])
GO
ALTER TABLE [dbo].[HoaDon] CHECK CONSTRAINT [FK_HoaDon_KhachHang]
GO
ALTER TABLE [dbo].[HopDong]  WITH CHECK ADD  CONSTRAINT [FK_HopDong_KhachHang] FOREIGN KEY([MaKhachHang])
REFERENCES [dbo].[KhachHang] ([MaKhachHang])
GO
ALTER TABLE [dbo].[HopDong] CHECK CONSTRAINT [FK_HopDong_KhachHang]
GO
ALTER TABLE [dbo].[HopDong]  WITH CHECK ADD  CONSTRAINT [FK_HopDong_Phong] FOREIGN KEY([MaPhong])
REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[HopDong] CHECK CONSTRAINT [FK_HopDong_Phong]
GO
ALTER TABLE [dbo].[KhachHang]  WITH CHECK ADD  CONSTRAINT [FK_KhachHang_Phong] FOREIGN KEY([MaPhong])
REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[KhachHang] CHECK CONSTRAINT [FK_KhachHang_Phong]
GO
ALTER TABLE [dbo].[Phong]  WITH CHECK ADD  CONSTRAINT [FK_Phong_LoaiPhong] FOREIGN KEY([MaLoaiPhong])
REFERENCES [dbo].[LoaiPhong] ([MaLoaiPhong])
GO
ALTER TABLE [dbo].[Phong] CHECK CONSTRAINT [FK_Phong_LoaiPhong]
GO
ALTER TABLE [dbo].[TrangBi]  WITH CHECK ADD  CONSTRAINT [FK_TrangBi_Phong] FOREIGN KEY([MaPhong])
REFERENCES [dbo].[Phong] ([MaPhong])
GO
ALTER TABLE [dbo].[TrangBi] CHECK CONSTRAINT [FK_TrangBi_Phong]
GO
ALTER TABLE [dbo].[TrangBi]  WITH CHECK ADD  CONSTRAINT [FK_TrangBi_ThietBi] FOREIGN KEY([MaThietBi])
REFERENCES [dbo].[ThietBi] ([MaThietBi])
GO
ALTER TABLE [dbo].[TrangBi] CHECK CONSTRAINT [FK_TrangBi_ThietBi]
GO
/****** Object:  StoredProcedure [dbo].[ChiDienNuocOfPhong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ChiDienNuocOfPhong](@maphong varchar(8), @thang int)
as
begin
	select dv.TenDichVu, ct.ChiSoCu, ct.ChiSoMoi ,(ct.ChiSoMoi - ct.ChiSoCu)  as 'SuDung', dv.DonGia,dv.DVT, (ct.ChiSoMoi - ct.ChiSoCu) * dv.DonGia as 'ThanhTien'
	from HoaDon hd, ChiTietDienNuoc ct, DichVu dv, KhachHang kh
	where hd.MaHoaDon = ct.MaHoaDon and ct.MaDichVu = dv.MaDichVu and kh.MaKhachHang = hd.MaHoaDon and kh.MaPhong = @maphong
	and dbo.KtraNgayLapThuocThang(hd.NgayLap , @thang) =1
end
GO
/****** Object:  StoredProcedure [dbo].[ChiTietHoaDonOfPhong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ChiTietHoaDonOfPhong](@maphong varchar(8), @thang int)
as
begin
	select dv.TenDichVu, ct.SoLuong , dv.DonGia,dv.DVT, ct.SoLuong * dv.DonGia as 'ThanhTien'
	from HoaDon hd, ChiTietHoaDon ct, DichVu dv, KhachHang kh
	where hd.MaHoaDon = ct.MaHoaDon and ct.MaDichVu = dv.MaDichVu and kh.MaKhachHang = hd.MaKhachHang and kh.MaPhong = @maphong
	and dbo.KtraNgayLapThuocThang(hd.NgayLap , @thang) =1
end
GO
/****** Object:  StoredProcedure [dbo].[DangNhap]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[DangNhap](@ten varchar(50),@mk varchar(50))
as
begin
	select * from TaiKhoan a where a.TenDangNhap = @ten and a.MatKhau = @mk
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_ChiTietDienNuoc]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Delete_ChiTietDienNuoc](@mahd int , @madv int)
as
begin
	delete from ChiTietDienNuoc where MaHoaDon = @mahd and MaDichVu = @madv
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_ChiTietHoaDon]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Delete_ChiTietHoaDon](@mahd int , @madv int)
as
begin
	delete from ChiTietHoaDon where MaHoaDon = @mahd and MaDichVu = @madv
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_DichVu]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Delete_DichVu](@ma int)
as
begin
    update ChiTietDienNuoc set MaDichVu  = '1' where MaDichVu = @ma
	update ChiTietHoaDon set MaDichVu  = '1' where MaDichVu = @ma
	delete DichVu where MaDichVu = @ma
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_HoaDon]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[Delete_HoaDon](@ma int)
as
begin
	delete from ChiTietDienNuoc where ChiTietDienNuoc.MaHoaDon = @ma
	delete from ChiTietHoaDon where ChiTietHoaDon.MaHoaDon = @ma
	delete from HoaDon where MaHoaDon = @ma
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_HopDong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Delete_HopDong] (@ma int)
as
begin
   delete HopDong where MaHopDong = @ma
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_KhachHang]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Delete_KhachHang] (@ma int)
as
begin
   delete HopDong where MaKhachHang = @ma
   delete from HoaDon where MaKhachHang= @ma
   delete KhachHang where MaKhachHang = @ma
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_LoaiPhong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Delete_LoaiPhong] (@ma int)
as
begin
   update Phong set MaLoaiPhong = null where MaLoaiPhong = @ma
   delete LoaiPhong where MaLoaiPhong = @ma
end
GO
/****** Object:  StoredProcedure [dbo].[Delete_Thietbi]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[Delete_Thietbi] (@ma int)
as
begin
   delete TrangBi  where MaThietBi = @ma
   delete ThietBi  where MaThietBi = @ma
  
end
GO
/****** Object:  StoredProcedure [dbo].[KhachHangChuaLamHopDong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[KhachHangChuaLamHopDong](@maphong varchar(8))
as
begin
	select *
	from KhachHang kh
	where kh.MaPhong = @maphong and kh.Status = 1
end
GO
/****** Object:  StoredProcedure [dbo].[List_ThietBi_of_Phong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[List_ThietBi_of_Phong](@ma varchar(10))
as
begin
    select tb.MaThietBi , tb.TenThietBi , tb.TinhTrang,tb.GhiChu
	from ThietBi tb, Phong p, TrangBi trb
	where tb.MaThietBi = trb.MaThietBi and trb.MaPhong= p.MaPhong and p.MaPhong = @ma

end
GO
/****** Object:  StoredProcedure [dbo].[ListDienNuoc]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ListDienNuoc]
as
begin
	select *
	from DichVu dv
	where dv.TenDichVu =N'Điện' or dv.TenDichVu =N'Nước'
end
GO
/****** Object:  StoredProcedure [dbo].[ListDVKhac]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[ListDVKhac]
as
begin
	select * from DichVu dv
	where dv.MaDichVu not in (select dv.MaDichVu
								from DichVu dv
								where dv.TenDichVu =N'Điện' or dv.TenDichVu =N'Nước')
end
GO
/****** Object:  StoredProcedure [dbo].[ListHopDongSapHetHan]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ListHopDongSapHetHan]
as
begin
	select *
	from HopDong hd
	where dbo.SoNgayConLaiCuaHopDong(hd.MaHopDong) <= 15
end
GO
/****** Object:  StoredProcedure [dbo].[ListKhachHangOfPhong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[ListKhachHangOfPhong](@maphong varchar(8))
as
begin
	select * from KhachHang
	where MaPhong = @maphong
end
GO
/****** Object:  StoredProcedure [dbo].[ListPhong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ListPhong]
as
begin
	select p.MaPhong , p.TenPhong , lp.DonGia  , kh.MaKhachHang, kh.HoTen
	from LoaiPhong lp, Phong p , KhachHang kh
	where p.MaLoaiPhong = lp.MaLoaiPhong and p.MaPhong = kh.MaPhong and kh.Status = 1
end
GO
/****** Object:  StoredProcedure [dbo].[ListPhongChuaDuNguoi]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ListPhongChuaDuNguoi]
as
begin
	select p.MaPhong , p.TenPhong, p.GhiChu , p.MaLoaiPhong
	from Phong p, KhachHang kh, LoaiPhong lp
	where p.MaLoaiPhong = lp.MaLoaiPhong and p.MaPhong = kh.MaPhong and lp.SoLuongToiDa > dbo.SoLuongNguoiTrongPhong(p.MaPhong)
	group by p.MaPhong , p.TenPhong, p.GhiChu , p.MaLoaiPhong
end
GO
/****** Object:  StoredProcedure [dbo].[ListPhongChuaLamHopDong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ListPhongChuaLamHopDong]
as
begin
	select p.MaPhong , p.TenPhong, p.GhiChu , p.MaLoaiPhong
	from KhachHang kh , Phong p
	where kh.Status =1 and kh.MaPhong = p.MaPhong and kh.MaKhachHang not in  (select hd.MaKhachHang from HopDong hd)
end
GO
/****** Object:  StoredProcedure [dbo].[ListPhongTrong]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ListPhongTrong]
as
begin
    select p.MaPhong,p.TenPhong,lp.DienTich,lp.DonGia,lp.SoLuongToiDa,lp.MoTa
    from LoaiPhong lp, Phong p
    where p.MaLoaiPhong = lp.MaLoaiPhong and p.MaPhong not in (select p2.MaPhong from Phong p2, KhachHang kh where p2.MaPhong = kh.MaPhong group by p2.MaPhong)
    group by p.MaPhong,p.TenPhong,lp.DienTich,lp.DonGia,lp.SoLuongToiDa,lp.MoTa
end
GO
/****** Object:  StoredProcedure [dbo].[Search_KhachHang]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[Search_KhachHang] (@ten nvarchar(40))
as
begin
     select MaKhachHang as 'Mã khách hàng', HoTen as 'Tên khách hàng' , NgaySinh as 'Ngày sinh', GioiTinh as 'Giới tính' , QueQuan as 'Quê Quán', SDT as 'SĐT', CMND as 'CMND/Căn cước', Status as 'Status', MaPhong as 'Mã phòng'
	 from KhachHang where HoTen like N'%'+@ten+'%';
end
GO
/****** Object:  StoredProcedure [dbo].[SoLuongNguoiToiDa]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SoLuongNguoiToiDa](@maphong varchar(8))
as
begin
	select lp.SoLuongToiDa
	from Phong p, LoaiPhong lp
	where p.MaPhong = @maphong and p.MaLoaiPhong = lp.MaLoaiPhong
end
GO
/****** Object:  StoredProcedure [dbo].[ViewDoanhThu]    Script Date: 5/29/2019 9:04:42 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[ViewDoanhThu](@thang int)
as
begin
	select p.MaPhong , p.TenPhong ,kh.HoTen ,lp.DonGia ,isnull(dbo.TongDVKhac(hd.MaHoaDon,@thang),0) as 'DVKhac', isnull(dbo.TongDVDienNuoc(hd.MaHoaDon,@thang),0) as'DienNuoc',isnull(dbo.TongDVKhac(hd.MaHoaDon,@thang) +dbo.TongDVDienNuoc(hd.MaHoaDon,@thang) + lp.DonGia ,0) as 'TongTien'
	from LoaiPhong lp join  Phong p on lp.MaLoaiPhong = p.MaLoaiPhong left join KhachHang kh on p.MaPhong = kh.MaPhong join HoaDon hd on kh.MaKhachHang = hd.MaKhachHang
	where dbo.[KtraNgayLapThuocThang](hd.NgayLap,@thang) =1
	group by p.MaPhong , p.TenPhong ,kh.HoTen ,lp.DonGia,isnull(dbo.TongDVKhac(hd.MaHoaDon,@thang),0), isnull(dbo.TongDVDienNuoc(hd.MaHoaDon,@thang),0) ,isnull(dbo.TongDVKhac(hd.MaHoaDon,@thang) +dbo.TongDVDienNuoc(hd.MaHoaDon,@thang) + lp.DonGia ,0)
end
GO
USE [master]
GO
ALTER DATABASE [QLPT] SET  READ_WRITE 
GO
