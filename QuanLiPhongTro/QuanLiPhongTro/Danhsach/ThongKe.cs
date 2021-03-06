﻿using QuanLiPhongTro.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuanLiPhongTro.Danhsach
{
    public class ThongKe
    {
        private static ThongKe instance;

        public static ThongKe Instance
        {
            get
            {
                if (instance == null) instance = new ThongKe();
                return ThongKe.instance;
            }
            private set { ThongKe.instance = value; }
        }
        public ThongKe() { }

        public List<PhongTrong> ListPTr()
        {
            List<PhongTrong> list = new List<PhongTrong>();
            string query = "ListPhongTrong";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                PhongTrong tkhd = new PhongTrong(i);
                list.Add(tkhd);
            }
            return list;
        }

        public List<Phong> ListPhong()
        {
            List<Phong> list = new List<Phong>();
            string query = "select * from Phong";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                Phong tkhd = new Phong(i);
                list.Add(tkhd);
            }
            return list;
        }
        public List<Phong> ListPhongChuaĐuNguoi()
        {
            List<Phong> list = new List<Phong>();
            string query = "ListPhongChuaDuNguoi";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                Phong tkhd = new Phong(i);
                list.Add(tkhd);
            }
            return list;
        }
        public List<Phong> ListPhongChuaLamHopDong()
        {
            List<Phong> list = new List<Phong>();
            string query = "ListPhongChuaLamHopDong";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                Phong tkhd = new Phong(i);
                list.Add(tkhd);
            }
            return list;
        }


        //ListKhachHangChuaLamHopDong
        public List<KhachHang> ListKhachHangChuaLamHopDong(string maphong)
        {
            List<KhachHang> list = new List<KhachHang>();
            string query = string.Format("KhachHangChuaLamHopDong '{0}'", maphong);//"KhachHangChuaLamHopDong ''";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                KhachHang tkhd = new KhachHang(i);
                list.Add(tkhd);
            }
            return list;
        }

        public List<PhongCoNguoi> PhongCoNguoi()
        {
            List<PhongCoNguoi> list = new List<PhongCoNguoi>();
            string query = string.Format("ListPhong");//"KhachHangChuaLamHopDong ''";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                PhongCoNguoi tkhd = new PhongCoNguoi(i);
                list.Add(tkhd);
            }
            return list;
        }


        public List<ThietBi> ListThietbi()
        {
            List<ThietBi> list = new List<ThietBi>();
            string query = "select * from ThietBi";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                ThietBi tktb = new ThietBi(i);
                list.Add(tktb);
            }
            return list;
        }
        public List<KhachHang> ListTruongPhong()
        {
            List<KhachHang> list = new List<KhachHang>();
            string query = "select * from KhachHang where Status = 1";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                KhachHang tktb = new KhachHang(i);
                list.Add(tktb);
            }
            return list;
        }



        public List<DichVu> ListDichVu()
        {
            List<DichVu> list = new List<DichVu>();
            string query = "select * from DichVu";
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                DichVu tktb = new DichVu(i);
                list.Add(tktb);
            }
            return list;
        }

        public List<ThietBi> ListThietBiofPhong(string maphong)
        {
            List<ThietBi> list = new List<ThietBi>();
            string query = string.Format("List_ThietBi_of_Phong '{0}'", maphong);
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                ThietBi tktb = new ThietBi(i);
                list.Add(tktb);
            }
            return list;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ThongKe"></param>
        /// <returns></returns>
        /// 

        public List<KhachHang> ListKhachHangofPhong(string maphong)
        {
            List<KhachHang> list = new List<KhachHang>();
            string query = string.Format("ListKhachHangOfPhong '{0}'", maphong);
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                KhachHang tktb = new KhachHang(i);
                list.Add(tktb);
            }
            return list;
        }

        public DataTable SoLuongNguoiToiDaOfPhong(string ma)
        {
            string query = string.Format("SoLuongNguoiToiDa'{0}'", ma);
            DataTable a = SQL.ThuVienSQL.Instance.Execute_Query(query);
            return a;
        }
        public List<CTHoaDon> ListCTHoaDon(string maphong, int thang)
        {
            List<CTHoaDon> list = new List<CTHoaDon>();
            string query = string.Format("ChiTietHoaDonOfPhong '{0}','{1}'", maphong,thang);
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                CTHoaDon tktb = new CTHoaDon(i);
                list.Add(tktb);
            }
            return list;
        }
        public List<CTDienNuoc> ListCTDienNuoc(string maphong, int thang)
        {
            List<CTDienNuoc> list = new List<CTDienNuoc>();
            string query = string.Format("ChiDienNuocOfPhong '{0}','{1}'", maphong, thang);
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                CTDienNuoc tktb = new CTDienNuoc(i);
                list.Add(tktb);
            }
            return list;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="DichVu"></param>
        /// <returns></returns>
        ///

        public List<DichVu> ListDVDienNuoc()
        {
            List<DichVu> list = new List<DichVu>();
            string query = string.Format("ListDienNuoc");
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                DichVu tktb = new DichVu(i);
                list.Add(tktb);
            }
            return list;
        }
        public List<DichVu> ListDVKhac()
        {
            List<DichVu> list = new List<DichVu>();
            string query = string.Format("ListDVKhac");
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                DichVu tktb = new DichVu(i);
                list.Add(tktb);
            }
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ThongKe"></param>
        /// <returns></returns>
        /// 

        public List<DoanhThu> ListDoanhThu(int thang)
        {
            List<DoanhThu> list = new List<DoanhThu>();
            string query = string.Format("ViewDoanhThu '{0}'",thang);
            DataTable table = new DataTable();
            table = SQL.ThuVienSQL.Instance.Execute_Query(query);

            foreach (DataRow i in table.Rows)
            {
                DoanhThu tktb = new DoanhThu(i);
                list.Add(tktb);
            }
            return list;
        }
    }
}
