unit datVariables;
(* menyimpan sebagian besar variabel yang akan digunakan 
 pada program utama, tak ada algoritma *)
 
{KAMUS}
interface

	{variabel file}
	
type TBarang = record
	jenis : string; {salah satu dalam daftar speks}
	penyedia : string;
	mataUang : string; {IDR, USD, EUR}
	harga : longint; {dalam mata uang tersedia}
	end;
{jenis: voucher HP, listrik pra bayar, taksi OL}

type TBayar = record
	noAkun : string; {panjang string 6}
	jenis : string; {salah satu yang di daftarkan speks}
	rekeningBayar : string;
	mataUang : string; {IDR, USD, EUR}
	jumlah : longint; {dalam mata uang rekening}
	saldo : longint;
	tanggal : string; {format tanggal mengikuti dd-mm-yyyy}
	end;
{jenis: bayar listrik, BPJS, PDAM, telpon, TV Kabel, internet, kartu kredit, pajak, biaya pendidikan}
	
type TBeli = record
	noAkun : string; {panjang string 6}
	jenis : string; {salah satu yang di daftarkan speks, jenis barang}
	penyedia : string;
	noTujuan : string;
	mataUang : string; {IDR, USD, EUR}
	jumlah : longint; {dalam mata uang rekening}
	saldo : longint;
	tanggal : string; {format tanggal mengikuti dd-mm-yyyy}
	end;
		
type TMataUang = record
	nilaiKursDari : real;
	kursDari : string; {IDR, USD, EUR}
	nilaiKursTujuan : real;
	kursTujuan : string; {IDR, USD, EUR}
	end;

type TNasabah = record
	noNasabah : string; {panjang string 6}
	nama : string;
	alamat : string;
	kota : string;
	email : string;
	telp : string;
	user : string;
	pass : string;
	status : string; {aktif atau tidak aktif}
	end;

type TRekening = record
	noAkun : string; {panjang string 6}
	noNasabah : string; {panjang string 6}
	jenis : string; {salah satu dari 3 jenis rekening online}
	mataUang : string; {IDR, USD, EUR}
	saldo : longint; {dalam mata uang yang menjadi standar rekening}
	setoranRutin : longint; {khusus TR dan DP, TM bernilai 0}
	rekeningAutodebet : string; {- jika kosong, khusus TR dan DP}
	jangkaWaktu : string; {bagian validasi ada di speks}
	tanggal : string; {format tanggal mengikuti dd-mm-yyyy}
	end;	
{jenis: tabungan mandiri, tabungan rencana, deposito}

type TSetorTarik = record
	noAkun : string; {panjang string 6}
	jenis : string; {setoran atau penarikan}
	mataUang : string; {IDR, USD, EUR}
	jumlah : longint; {dalam rekening}
	saldo : longint; 
	tanggal : string; {format tanggal mengikuti dd-mm-yyyy}
	end;
	
type TTransfer = record
	noAkunDari : string; {panjang string 6}
	noAkunTujuan : string; {panjang string 6}
	jenis : string; {dalam bank atau antar bank}
	namaBankLuar : string; {- jika dalam bank}
	mataUang : string; {IDR, USD, EUR, berupa mata uang rekening}
	jumlah : longint; {dalam mata uang rekening}
	saldo : longint;
	tanggal : string; {format tanggal mengikuti dd-mm-yyyy}
	end;
	
var
	FBarang : file of TBarang; {format valid: .bar}
	FBayar : file of TBayar; {format valid: .byr}
	FBeli : file of TBeli; {format valid: .bel}
	FMataUang : file of TMataUang; {format valid: .mu, harus penuh}
	FNasabah : file of TNasabah; {format valid: .nas, jika kosong maka tidak dapat login}
	FRekening : file of TRekening; {format valid: .rek}
	FSetorTarik : file of TSetorTarik; {format valid: .st}
	FTransfer : file of TTransfer; {format valid: .trs}

	{array penyimpan data pada file}

const NMax = 10; {NMax kecil demi kemudahan mengisi file sampai full} 

type TTabBarang = record		
	barangArray : array[1..NMax] of TBarang;
	nEff : integer;
	end;

	TTabBayar = record	
	bayarArray : array[1..NMax] of TBayar;
	nEff : integer;
	end;
		
	TTabBeli = record	
	beliArray : array[1..NMax] of TBeli;
	nEff : integer;
	end;

	TTabNasabah = record	
	nasabahArray : array[1..NMax] of TNasabah;
	nEff : integer;
	end;

	TTabRekening = record	
	rekeningArray : array[1..NMax] of TRekening;
	nEff : integer;
	end;

	TTabSetorTarik = record	
	setorTarikArray : array[1..NMax] of TSetorTarik;
	nEff : integer;
	end;
	
	TTabTransfer = record	
	transferArray : array[1..NMax] of TTransfer;
	nEff : integer;
	end;
	
var
	TabBarang : TTabBarang;
	TabBayar : TTabBayar;
	TabBeli : TTabBeli;
	TabNasabah : TTabNasabah;
	TabRekening : TTabRekening;
	TabSetorTarik : TTabSetorTarik;
	TabTransfer : TTabTransfer;
	
	mataUang : TMataUang;
	
	{variabel lain}
var
	usd : real = 0; {hasil konversi 1 IDR ke mata uang USD, dibaca dari FMataUang}
	eur : real = 0; {hasil konversi 1 IDR ke mata uang EUR, dibaca dari FMataUang}
	currNasabah : string; {nomor akun nasabah setelah berhasil login}
	currDate : string; {tanggal saat login}
	
implementation

begin
end.
