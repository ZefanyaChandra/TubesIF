unit commands;
{$MODE OBJFPC}
interface
uses datVariables, SysUtils, DateUtils;

{ beberapa bagian interface terpakai di bagian-bagian lain }
(* bagian interface untuk F1 dan F15 *)
var
	s : string;

procedure readFile(nama : string; ext : string);
procedure readFile2(nama : string; ext : string);
procedure load;
procedure exit;

(* bagian interface untuk F2 - F5 *)
	{type tersebut digunakan untuk proses F2 - login}
type counter = record
		username : string;
		jumlahsalah : integer;
		end;
		
	Tabcount = record
		arr : array [1..NMax] of counter;
		nEff : integer;
		end;


function findIdxNas (T : TTabNasabah; username : string) : integer;
function findIdxRek (T : TTabRekening; noRek : string) : integer;
function findIdxCount (T : TabCount; username : string) : integer;
procedure login(T : TTabNasabah; var noAcc : string; var logstatus : boolean);
procedure tulisRek(T : TTabRekening; noAcc : string);
procedure lihatSaldo (T : TTabRekening);
procedure lihatAktivitas(T : TTabRekening; Tsetortarik : TTabSetorTarik; Ttransfer : TTabTransfer; Tpembayaran : TTabBayar; Tpembelian : TTabBeli);

(* bagian interface untuk F6 - F9 *)

function randomAkun : string; {dibuat oleh William}
procedure opsiAutodebet(var R : TRekening);	
procedure buatRekening;
procedure pilihRekening(var Rek : TRekening);
procedure konversi(var jumlah : longint; mu1, mu2 : string);
function validasiTempo(Rek : TRekening) : boolean;
procedure setor;
procedure tarik;
procedure transfer;

(* bagian interface untuk F10 dan F11 *)
procedure bayar;
procedure beli;

(* bagian interface untuk F12 - F14 *)
procedure deleteRekening(i : integer; var rekeningOnlineArray : TTabRekening);
procedure tutupRekening();
procedure perubahanDataNasabah();
procedure penambahanAutoDebet();


implementation

(* F1 dan F15 oleh William *)

procedure readFile(nama : string; ext : string);
{ I.S. : Suatu f terdefinisi }
{ F.S. : fungsi menghasilkan true jika extension sebuah file sesuai yang diinginkan }
begin
	repeat
		write('> Masukkan file data ', nama, ' (', ext, '): ');
		readln(s);
		if not(RightStr(s, 4) = ext) then
		begin
			writeln('> Kesalahan format file!');
			writeln('> ');
		end;
	until (RightStr(s, 4) = ext);
end;

procedure readFile2(nama : string; ext : string);
{ I.S. : Suatu f terdefinisi }
{ F.S. : fungsi menghasilkan true jika extension sebuah file sesuai yang diinginkan }
{ versi kedua, karena ada extension yang 2 huruf}
begin
	repeat
		write('> Masukkan file data ', nama, ' (', ext, '): ');
		readln(s);
		if not(RightStr(s, 3) = ext) then
		begin
			writeln('> Kesalahan format file!');
			writeln('> ');
		end;
	until (RightStr(s, 3) = ext);
end;

procedure load;
{ I.S. : Tidak ada }
{ F.S. : Tiap array penyimpan data dan file yang digunakan terdefinisi }
{ Kamus Lokal }
{ File-file tersebut harus berada dalam folder yang sama }
{ Isi dari file belum divalidasi }

var
	n : integer;
	convertUSDtoEUR : real = 0; {perbandingan EUR/USD}
	
{ Algoritma }
begin
	repeat
		begin
			readFile('nasabah', '.nas');
			if (FileExists(s)) then
			begin
				assign(FNasabah, s);
				reset(FNasabah);
				n := 0; {inisialisasi}
				while not(eof(FNasabah)) do
				begin
					n := n + 1;
					read(FNasabah, TabNasabah.nasabahArray[n]);
				end;
				TabNasabah.nEff := n;
				close(FNasabah);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));

	repeat
		begin
			readFile('rekening online', '.rek');
			if (FileExists(s)) then
			begin
				assign(FRekening, s);
				reset(FRekening);
				n := 0; {inisialisasi}
				while not(eof(FRekening)) do
				begin
					n := n + 1;
					read(FRekening, TabRekening.rekeningArray[n]);
				end;
				TabRekening.nEff := n;
				close(FRekening);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));

	repeat
		begin
			readFile2('transaksi setoran/penarikan', '.st');
			if (FileExists(s)) then
			begin
				assign(FSetorTarik, s);
				reset(FSetorTarik);
				n := 0; {inisialisasi}
				while not(eof(FSetorTarik)) do
				begin
					n := n + 1;
					read(FSetorTarik, TabSetorTarik.setorTarikArray[n]);
				end;
				TabSetorTarik.nEff := n;
				close(FSetorTarik);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));

	repeat
		begin
			readFile('transaksi transfer', '.trs');
			if (FileExists(s)) then
			begin
				assign(FTransfer, s);
				reset(FTransfer);
				n := 0; {inisialisasi}
				while not(eof(FTransfer)) do
				begin
					n := n + 1;
					read(FTransfer, TabTransfer.transferArray[n]);
				end;
				TabTransfer.nEff := n;
				close(FTransfer);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));

	repeat
		begin
			readFile('transaksi pembayaran', '.byr');
			if (FileExists(s)) then
			begin
				assign(FBayar, s);
				reset(FBayar);
				n := 0; {inisialisasi}
				while not(eof(FBayar)) do
				begin
					n := n + 1;
					read(FBayar, TabBayar.bayarArray[n]);
				end;
				TabBayar.nEff := n;
				close(FBayar);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));

	repeat
		begin
			readFile('transaksi pembelian', '.bel');
			if (FileExists(s)) then
			begin
				assign(FBeli, s);
				reset(FBeli);
				n := 0; {inisialisasi}
				while not(eof(FBeli)) do
				begin
					n := n + 1;
					read(FBeli, TabBeli.beliArray[n]);
				end;
				TabBeli.nEff := n;
				close(FBeli);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s));
	
	{bagian pemrosesan load pada FMataUang berbeda, hanya akan disimpan 2 variabel}
	{file ini akan penuh jika dimasukkan 2 baris data}
	repeat
		begin
			readFile2('nilai tukar antar mata uang', '.mu');
			if (FileExists(s)) then
			begin
				assign(FMataUang, s);
				reset(FMataUang);
				while not(eof(FMataUang)) do
				begin
					read(FMataUang, mataUang);
					if (mataUang.kursDari = 'IDR') then
					begin
						if (mataUang.kursTujuan = 'USD') then
							usd := mataUang.nilaiKursTujuan / mataUang.nilaiKursDari
						else {maka kursTujuan EUR}
							eur := mataUang.nilaiKursTujuan / mataUang.nilaiKursDari;
					end
					else if (mataUang.kursTujuan = 'IDR') then
					begin
						if (mataUang.kursDari = 'USD') then
							usd := mataUang.nilaiKursDari / mataUang.nilaiKursTujuan
						else {maka kursTujuan EUR}
							eur := mataUang.nilaiKursDari / mataUang.nilaiKursTujuan;
					end
					else
					begin
						if (mataUang.kursDari = 'USD') and (mataUang.kursTujuan = 'EUR') then
							convertUSDtoEUR := mataUang.nilaiKursTujuan / mataUang.nilaiKursDari
						else {maka kursDari EUR dan kursTujuan USD}
							convertUSDtoEUR := mataUang.nilaiKursDari / mataUang.nilaiKursTujuan;
					end;
				end;
				close(FMataUang);
				writeln('> File berhasil di-load!');
				if (usd = 0) or (eur = 0) then
					if (convertUSDtoEUR = 0) then
						writeln('> File Mata Uang tidak lengkap! Silakan menggunakan file lain.')
					else
					begin
						if (usd = 0) then
							usd := convertUSDtoEUR * eur
						else {eur = 0}
							eur := usd / convertUSDtoEUR;
					end;
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> ');
	until(FileExists(s)) and not((usd = 0) or (eur = 0));
	
	repeat
		begin
			readFile('barang', '.bar');
			if (FileExists(s)) then
			begin
				assign(FBarang, s);
				reset(FBarang);
				n := 0; {inisialisasi}
				while not(eof(FBarang)) do
				begin
					n := n + 1;
					read(FBarang, TabBarang.barangArray[n]);
				end;
				TabBarang.nEff := n;
				close(FBarang);
				writeln('> File berhasil di-load!');
			end
			else
				writeln('> File tidak ditemukan!');
		end;
		writeln('> Load file bank sukses!');
	until(FileExists(s));

end;

(* F2 - F5 oleh Zefanya, dengan berbagai modifikasi pada sumber kode *)

function findIdxNas (T : TTabNasabah; username : string) : integer;
{ I.S. : T terdefinisi, T.N>0, user terdefinisi }
{ F.S. : menghasilkan indeks ditemukannya username, 0 jika tidak ditemukan dalam T }
{ Kamus Lokal }
var
	i : integer;
{ Algoritma }	
begin
	i:=1;
	while ((i <= T.nEff) and (T.nasabahArray[i].user <> username)) do 
	begin
		i:=i+1;
	end; 
	if (i > T.nEff) then 
	begin
		findIdxNas := 0;
	end else
	begin
		findIdxNas := i;
	end;	
end;

function findIdxRek (T : TTabRekening; noRek : string) : integer;
{ I.S. : T terdefinisi, T.N>0, noRek terdefinisi }
{ F.S. : menghasilkan indeks ditemukannya noRek, 0 jika tidak ditemukan dalam T }
{ Kamus Lokal }
var
	i : integer;
{ Algoritma }	
begin
	i := 1;
	while (i <= T.nEff) and (T.rekeningArray[i].noAkun <> noRek) do 
	begin
		i := i+1;
	end; 
	if (i > T.nEff) or not(T.rekeningArray[i].noNasabah = currNasabah) then 
	begin
		findIdxRek := 0;
	end else
	begin
		findIdxRek := i;
	end;	
end;

function findIdxCount (T : TabCount; username : string) : integer;
{ I.S. : T terdefinisi, T.N>0, user terdefinisi }
{ F.S. : menghasilkan indeks ditemukannya username, 0 jika tidak ditemukan dalam T }
{ Kamus Lokal }
var
	i:integer;
{ Algoritma }	
begin
	i := 1;
	while ((i <= T.nEff) and (T.arr[i].username <> username)) do 
	begin
		i := i+1;
	end; 
	if (i > T.nEff) then 
	begin
		findIdxCount := 0;
	end else
	begin
		findIdxCount := i;
	end;	
end;

procedure login(T : TTabNasabah; var noAcc : string; var logstatus : boolean);
{ I.S. : T terdefinisi }
{ F.S. : masuk ke menu utama jika input username dan password benar, jika password salah 3 kali maka status nasabah menjadi inaktif }
{ F.S. : menuliskan login berhasil dan noAcc terdefinisi }
{ Kamus Lokal }

var
	i, Idx, Idxcount : integer;
	user, password : string;
	Tcounter : Tabcount;
	
{ Algoritma }
begin
	for i := 1 to NMax do
	begin
		Tcounter.arr[i].jumlahsalah := 0;
	end;
	Tcounter.nEff := 0;
	logstatus := False;
	while (not(logstatus)) do
	begin
		repeat
			write('> Username : '); readln(user);
			if (findIdxNas(T,user) = 0) then writeln ('> Username salah!');
		until (findIdxNas(T,user) <> 0);
		Idx := findIdxNas(T,user);
		if (T.nasabahArray[Idx].status = 'aktif') then
		begin
			write('> Password : '); readln(password);
			if (T.nasabahArray[Idx].pass <> password) then 
			begin
				Idxcount := findIdxCount(Tcounter,user);
				if (Idxcount = 0) then
				begin
					Tcounter.nEff := Tcounter.nEff+1;
					Idxcount := Tcounter.nEff;
				end;
				Tcounter.arr[Idxcount].username := user;
				Tcounter.arr[Idxcount].jumlahsalah := Tcounter.arr[Idxcount].jumlahsalah + 1;
				writeln('> Password salah!');
				writeln('> Attempts remaining : ', 3 - Tcounter.arr[Idxcount].jumlahsalah);
				if (Tcounter.Arr[Idxcount].jumlahsalah >= 3) then
				begin
					T.nasabahArray[Idx].status:='tidak aktif';
				end;
				writeln('> ');
			end else
			begin
				logstatus := True;
				noAcc := T.nasabahArray[Idx].noNasabah;
				writeln('> Login berhasil!');
			end;
		end else
		begin
			writeln('> Status nasabah inaktif,');
		end;
	end;
end;

procedure tulisRek(T : TTabRekening; noAcc : string);
{ I.S. : T terdefinisi, T.N>0, noAcc terdefinisi }
{ F.S. : menghasilkan semua nomor rekening milik nasabah }
{ Kamus Lokal }
var
	i : integer;
{ Algoritma }
begin
	for i := 1 to T.nEff do
	begin
		if (T.rekeningArray[i].noNasabah = noAcc) then
		begin
			writeln('> ', T.rekeningArray[i].noAkun);
			writeln('> Jenis: ', T.rekeningArray[i].jenis);
			if (T.rekeningArray[i].jenis = 'tabungan rencana') then
				writeln('> Setoran rutin: ', T.rekeningArray[i].setoranRutin);
			if not(T.rekeningArray[i].jenis = 'tabungan mandiri') then
				writeln('> Rekening autodebet: ', T.rekeningArray[i].rekeningAutodebet);
			if not(T.rekeningArray[i].jenis = 'tabungan mandiri') then	
				writeln('> Jangka waktu: ', T.rekeningArray[i].jangkawaktu);
			writeln('> Tanggal pembuatan: ', T.rekeningArray[i].tanggal);
			write('> Tekan Enter untuk melanjutkan.');
			readln;
			writeln('> ');
		end;
	end;
end;

procedure lihatSaldo (T : TTabRekening);
{ I.S. : T terdefinisi, T.N>0}
{ F.S. : menghasilkan saldo dari nomor rekening input jika ada, memberi pesan kesalahan jika rekening tidak ada }
{ Kamus Lokal }
var
	Idx : integer;
	noRek : string;
{ Algoritma }
begin
	write('> Pilih rekening : '); readln(noRek);
	Idx := findIdxRek(T, noRek);
	if not(Idx = 0) then
		writeln('> Saldo : ',T.rekeningArray[Idx].mataUang, T.rekeningArray[Idx].saldo)
	
	else
		writeln('> Rekening tidak ditemukan!');
end;


procedure lihatAktivitas(T : TTabRekening; Tsetortarik : TTabSetorTarik; Ttransfer : TTabTransfer; Tpembayaran : TTabBayar; Tpembelian : TTabBeli);
{ I.S. : tiap jenis T terdefinisi, noAcc terdefinisi }
{ F.S. : menuliskan informasi transaksi yang terjadi dalam jangka waktu tertentu }
{ Kamus Lokal }
var
	selisih, i, jangkawaktu : integer;
	first, empty : boolean;
	Idx : integer;
	noRekening : string;
	
{ Algoritma }
begin
	write('> Pilih rekening : '); readln(noRekening);
	Idx := findIdxRek(T, noRekening);
	if not(Idx = 0) then
	begin
		write('> Jangka waktu (hari) : '); readln(jangkawaktu);
		if (jangkawaktu >= 1) and (jangkawaktu <= 90) then
		begin
			first := True;
			if not(Tsetortarik.nEff = 0) then
			for i := 1 to Tsetortarik.nEff do
				begin
					selisih := DaysBetween(StrToDate(Tsetortarik.setorTarikArray[i].tanggal), Date);
					if ((Tsetortarik.setorTarikArray[i].noAkun = noRekening) and (selisih <= jangkawaktu)) then
					begin
						if (first) then
						begin
							writeln('> SETOR/TARIK');
							first := False;
							empty := False;
						end;
						writeln('> ', Tsetortarik.setorTarikArray[i].jenis,' | ',Tsetortarik.setorTarikArray[i].mataUang,' | ',Tsetortarik.setorTarikArray[i].jumlah,' | ',Tsetortarik.setorTarikArray[i].saldo,' | ',Tsetortarik.setorTarikArray[i].tanggal);
					end;
					if (i mod 5 = 0) then
					begin
						writeln('> ');
						write('> Tekan Enter untuk melanjutkan.');
						readln;
						writeln('> ');
					end;
				end;
			
			first := True;
			if not(Ttransfer.nEff = 0) then
				for i := 1 to Ttransfer.nEff do
				begin
					selisih := DaysBetween(StrToDate(Ttransfer.transferArray[i].tanggal), Date);
					if ((Ttransfer.transferArray[i].noAkunDari = noRekening) or (Ttransfer.transferArray[i].noAkunTujuan = noRekening)) and (selisih <= jangkawaktu) then
					begin
						if (first) then
						begin
							writeln('> TRANSFER');
							first := False;
							empty := False;
						end;
						writeln('> ', Ttransfer.transferArray[i].noAkunDari,' | ',Ttransfer.transferArray[i].noAkunTujuan,' | ',Ttransfer.transferArray[i].jenis,' | ',Ttransfer.transferArray[i].namaBankLuar,' | ',Ttransfer.transferArray[i].mataUang,' | ',Ttransfer.transferArray[i].jumlah,' | ',Ttransfer.transferArray[i].saldo,' | ',Ttransfer.transferArray[i].tanggal);
					end;
				end;
			
			first := True;
			if not(Tpembayaran.nEff = 0) then
				for i := 1 to Tpembayaran.nEff do
				begin
					selisih := DaysBetween(StrToDate(Tpembayaran.bayarArray[i].tanggal),Date);
					if ((Tpembayaran.bayarArray[i].noAkun = noRekening) and (selisih <= jangkawaktu)) then
					begin
						if (first) then
						begin
							writeln('> PEMBAYARAN');
							first := False;
							empty := False;
						end;
						writeln('> ', Tpembayaran.bayarArray[i].noAkun,' | ',Tpembayaran.bayarArray[i].jenis,' | ',Tpembayaran.bayarArray[i].rekeningBayar,' | ',Tpembayaran.bayarArray[i].mataUang,' | ',Tpembayaran.bayarArray[i].jumlah,' | ',Tpembayaran.bayarArray[i].saldo,' | ',Tpembayaran.bayarArray[i].tanggal);
					end;
					if (i mod 5 = 0) then
					begin
						writeln('> ');
						write('> Tekan Enter untuk melanjutkan.');
						readln;
						writeln('> ');
					end;
				end;
			
			first := True;
			if not(Tpembelian.nEff = 0) then
				for i := 1 to Tpembelian.nEff do
				begin
					selisih := DaysBetween(StrToDate(Tpembelian.beliArray[i].tanggal), Date);
					if ((Tpembelian.beliArray[i].noAkun = noRekening) and (selisih <= jangkawaktu)) then
					begin
						if (first) then
						begin
							writeln('> PEMBELIAN');
							first := False;
							empty := False;
						end;
						writeln('> ', Tpembelian.beliArray[i].noAkun,' | ',Tpembelian.beliArray[i].jenis,' | ',Tpembelian.beliArray[i].penyedia,' | ',Tpembelian.beliArray[i].noTujuan,' | ',Tpembelian.beliArray[i].mataUang,' | ',Tpembelian.beliArray[i].jumlah,' | ',Tpembelian.beliArray[i].saldo,' | ',Tpembelian.beliArray[i].tanggal);
					end;
					if (i mod 5 = 0) then
					begin
						writeln('> ');
						write('> Tekan Enter untuk melanjutkan.');
						readln;
						writeln('> ');
					end;
				end;
			
			if (empty) then
				writeln('> Tidak ada transaksi selama jangka waktu tersebut.');
		end else
		begin
			writeln('> Jangka waktu invalid!');
			writeln('> Anda dapat melihat aktivitas transaksi dari 1 hari sampai');
			writeln('> 3 bulan (90 hari) lalu.');
		end;
	end else
		writeln('> Rekening tidak ditemukan!');
end;

(* F6 - F9 oleh Prahasto, dengan bebagai modifikasi pada sumber kode *)

function randomAkun : string;
{ I.S. : tidak ada }
{ F.S. : suatu akun acak }
var
	A : array[0..25] of char = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
	x1, x2, x3, x4 : string;
	s1 : string;
begin
	randomize;
	x1 := IntToStr(random(10));
	x2 := IntToStr(random(10));
	x3 := IntToStr(random(10));
	x4 := IntToStr(random(10));
	s1 := A[random(26)] + A[random(26)];
	randomAkun := x1 + s1 + x2 + x3 + x4;
end;

procedure opsiAutodebet(var R : TRekening);						
{ I.S. : R tak terdefinisi }
{ F.S. : R.rekeningAutodebet terdefinisi }
{ Kamus Lokal }
var
	i : integer = 0;
	j : integer = 0;
	k : integer = 0;
	cek : boolean = false;
	z : integer;
	akun : array [1..NMax] of string;
	
{ Algoritma }
begin
	if not(TabRekening.nEff = 0) then
		repeat
			i := i + 1;
			repeat
				j := j + 1;
			until ((TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah)) or (j = TabRekening.nEff);
			if ((TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah)) then
			begin
				if (i = 1) then
				begin
					cek := true;
					writeln('> Pilih Rekening Autodebet');
					writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
				end else 
				begin
					writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
				end;
				akun[i] := TabRekening.rekeningArray[j].noAkun;
			end;
		until (j = TabRekening.nEff);
									
		if (cek) then
		begin
		writeln('> 0. Tidak ingin memilih');
			write('> '); readln(z); {pilihan}
			if (z < 0) or (z > i) then
			begin
				repeat
					writeln('> Masukan salah, coba lagi!');
					write('> '); readln(z); {pilihan}
				until (z >= 0) and (z <= i);
			end;
			if not(z = 0) then
			begin
				if (z >= 0) and (z <= i) then begin
					k := 0;
					repeat
						k := k + 1;
						if (z = k) then
							R.rekeningAutodebet := akun[k];
					until (z = k);
				end
			end
			else
				R.rekeningAutodebet := '-';
			end
		else
			R.rekeningAutodebet := '-';
end;

procedure buatRekening;
{F6 : Pembuatan Rekening Online}
{ Kamus Lokal }
var
	Rek : TRekening;
	x, y : string;
	waktu : integer;
	
{ Algoritma }
begin
	repeat
		begin
			Rek.noNasabah := currNasabah;
			writeln('> Jenis rekening apa yang ingin anda gunakan?');
			writeln('> 1. deposito');
			writeln('> 2. tabungan mandiri');
			writeln('> 3. tabungan rencana');
			write('> '); readln(x); {pilihan}
			while (x <> '1') and (x <> '2') and (x <> '3') do
			begin
				writeln('> Masukan salah! Mohon isi ulang!');
				write('> '); readln(x); {pilihan}
			end;
			writeln('> ');
			case (x) of
			
				'1' : begin
						Rek.jenis := 'deposito';
						Rek.noAkun := randomAkun;
						writeln('> Pilih mata uang: ');
						writeln('> 1. IDR');
						writeln('> 2. USD');
						writeln('> 3. EUR');
						write('> '); readln(y); {pilihan}
						while (y <> '1') and (y <> '2') and (y <> '3') do
						begin
							writeln('> Masukan salah! Mohon isi ulang!');
							write('> '); readln(y); {pilihan}
						end;
						writeln('> ');
						write('> Masukkan saldo = ');
						case (y) of
						
							'1' : begin
								Rek.mataUang := 'IDR';
								readln(Rek.saldo);
								while (Rek.saldo < 8000000) do
								begin
									writeln('> Masukan kurang dari IDR8.000.000! Mohon isi ulang!');
									write('> Saldo = '); readln(Rek.saldo);
								end;
								
							end;
							
							'2' : begin
								Rek.mataUang := 'USD';
								readln(Rek.saldo);
								while (Rek.saldo < 600) do
								begin
									writeln('> Masukan kurang dari USD600! Mohon isi ulang!');
									write('> Saldo = '); readln(Rek.saldo);
								end;
							end;
							
							'3' : begin
								Rek.mataUang := 'EUR';
								readln(Rek.saldo);
								while (Rek.saldo < 550) do
								begin
									writeln('> Masukan kurang dari EUR550! Mohon isi ulang!');
									write('> Saldo = '); readln(Rek.saldo);
								end;
							end;
						end;
						write('> Masukkan setoran bulanan = ');
						readln(Rek.setoranRutin);
						while (Rek.setoranRutin < 0) do
						begin
							writeln('> Maaf, masukan Anda bilangan negatif, mohon isi ulang!');
							write('> Setoran bulanan = '); readln(Rek.setoranRutin);
						end;
						writeln('> Jangka waktu deposito dapat berupa 1, 3, 6, 12 bulan.');
						write('> Masukkan jangka waktu (dalam bulan) = ');
						readln(waktu);
						while (waktu <> 1) and (waktu <> 3) and (waktu <> 6) and (waktu <> 12) do
						begin
							writeln('> Maaf, pilihan Anda tidak sesuai, mohon isi ulang!');
							write('> Jangka waktu = '); readln(waktu);
						end;
						Rek.jangkaWaktu := (IntToStr(waktu)) + ' bulan';
						
						opsiAutodebet(Rek);
				end;
				'2' : begin
						Rek.jenis := 'tabungan mandiri';
						Rek.noAkun := randomAkun;
						Rek.mataUang := 'IDR';
						write('> Masukkan saldo = ');
						readln(Rek.saldo);
						while (Rek.saldo < 50000) do
						begin
							writeln('> Masukan kurang dari IDR50.000! Mohon isi ulang!');
							write('> '); readln(Rek.saldo);
						end;
						Rek.setoranRutin := 0; {asumsi tabungan mandiri tidak ada setoran rutin}
						Rek.rekeningAutodebet := '-';
						Rek.jangkaWaktu := '-';
				end;
				'3' : begin
						Rek.jenis := 'tabungan rencana';
						Rek.noAkun := randomAkun;
						Rek.mataUang := 'IDR';
						write('> Masukan saldo = ');
						readln(Rek.saldo);
						while (Rek.saldo < 0) do
						begin
							writeln('> Masukan kurang dari 0, mohon isi ulang!');
							write('> '); readln(Rek.saldo);
						end;
						write('> Masukan setoran bulanan = ');
						readln(Rek.setoranRutin);
						while (Rek.setoranRutin < 50000) do
						begin
							writeln('> Anda harus memasukkan minimal IDR50.000, mohon isi ulang!');
							write('> '); readln(Rek.setoranRutin);
						end;
						writeln('> Jangka waktu tabungan rencana dapat berupa 1-20 tahun.');
						write('> Masukkan jangka waktu (dalam tahun) = ');
						readln(waktu);
						while (waktu < 1) or (waktu > 20) do
						begin
							writeln('> Maaf, pilihan Anda tidak sesuai, mohon isi ulang!');
							write('> '); readln(waktu);
						end;
						Rek.jangkaWaktu := (IntToStr(waktu)) + ' tahun';
						
						opsiAutodebet(Rek);
				end;
			end;
			writeln('> ');
			writeln('> Rekening berhasil dibuat! Nomor akun : ' + Rek.noAkun);
			Rek.tanggal := currDate;
			TabRekening.nEff := TabRekening.nEff + 1;
			TabRekening.rekeningArray[TabRekening.nEff] := Rek;
			writeln('> Apakah Anda ingin membuat kembali? (y/n)');
			write('> '); readln(x); {recycle variabel x}
			while (x <> 'y') and (x <> 'n') do {validasi pilihan}
			begin
				writeln('> Masukan Anda salah, coba lagi!');
				write('> '); readln(x);
			end;
		end;
	until (x = 'n');
end;

procedure pilihRekening(var Rek : TRekening);
{ I.S. currNasabah terdefinisi }
{ F.S. hasil berupa rekening pilihan }
{ Kamus lokal }
var
	i : integer = 0;
	j : integer = 0;
	k : integer;
	akun : array [1..NMax] of TRekening;
	error : boolean;
	
{ Algoritma }
begin
	repeat
		i := i + 1;
		repeat
			j := j + 1;
		until (TabRekening.rekeningArray[j].noNasabah = currNasabah) or (j = TabRekening.nEff);
		if (TabRekening.rekeningArray[j].noNasabah = currNasabah) then
		begin
			if (i = 1) then
			begin
				writeln('> Pilih Rekening : ');
				writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
			end else 
			begin
				writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
			end;
		akun[i] := TabRekening.rekeningArray[j];
		end;
	until (j = TabRekening.nEff);
	
	error := True;
	repeat
		try
			write('> '); readln(k);
			error := False;
		except
			writeln('> Input harus berupa angka!');
		end;
	until not(error);
	if (k < 1) or (k > i) then
		begin
			repeat
				writeln('> Masukan salah, coba lagi!');
				write('> '); readln(k); {pilihan}
			until (k >= 1) and (k <= i);
		end
	else
		Rek := akun[k];
end;

procedure konversi(var jumlah : longint; mu1, mu2 : string);
{ I.S. jml dan mu1 dan mu2 terdefinisi }
{ F.S. jml nilainya dari mata uang asal, mu1, menjadi mata uang tujuan, mu2 }
{ Kamus Lokal }
var
	jml : real;
{ Algoritma }
begin
	if not(mu1 = mu2) then
	begin
		jml := jumlah;
		if (mu1 = 'USD') then
		begin
			if (mu2 = 'IDR') then
				jml := jml/usd
			else {mu2 = 'EUR'}
				jml := jml*eur/usd;
		end
		else if (mu1 = 'EUR') then
		begin
			if (mu2 = 'IDR') then
				jml := jml/eur
			else {mu2 = 'USD'}
				jml := jml*usd/eur;
		end
		else {mu1 = 'IDR'}
		begin
			if (mu2 = 'USD') then
				jml := jml*usd
			else {mu2 = 'EUR'}
				jml := jml*eur;
		end;
		jumlah := round(jml);
	end;
end;

function validasiTempo(Rek : TRekening) : boolean;
{ I.S. : suatu TRekening terdefinisi }
{ F.S. : function True jika sudah jatuh tempo, False jika belum }
{Menggunakan waktu sistem, tidak 100% akurat}
{ Kamus Lokal }
var
	waktu : integer;
{ Algoritma }
begin
	if (Rek.jenis = 'deposito') then
		begin
			waktu := StrToInt(LeftStr(Rek.jangkaWaktu, pos(' ', Rek.jangkaWaktu) - 1));
			if (MonthsBetween(StrToDate(Rek.tanggal), Date) < waktu) then
				validasiTempo := False
			else
				validasiTempo := True;
		end
	else if (Rek.jenis = 'tabungan rencana') then 
		begin
			waktu := StrToInt(LeftStr(Rek.jangkaWaktu, pos(' ', Rek.jangkaWaktu) - 1));
			if (YearsBetween(StrToDate(Rek.tanggal), Date) < waktu) then
				validasiTempo := False
			else
				validasiTempo := True;
		end
	else {jenis tabungan adalah tabungan mandiri}
		validasiTempo := True;
end;

procedure setor;
{ I.S. TabRekening berisi lebih dari 1}
{ F.S. TabSetorTarik datanya bertambah 1, saldo rekening bertambah}

{ Kamus Lokal }
var
	Rek : TRekening; 
	x, mu : string;
	Trans : TSetorTarik;
{ Algoritma }

begin
		pilihRekening(Rek);
		Trans.noAkun := Rek.noAkun;
		Trans.mataUang := Rek.mataUang;
		Trans.saldo := Rek.saldo;
		
		Trans.jenis := 'setoran';
		writeln('> Diingatkan bahwa mata uang rekening ini adalah ' + Rek.mataUang);
		write('> Mata uang jumlah yang disetorkan = ');
		readln(mu);
		while (mu <> 'IDR') and (mu <> 'USD') and (mu <> 'EUR') do
		begin
			writeln('> Mata uang hanya boleh IDR, USD atau EUR, mohon isi ulang!');
			write('> '); readln(mu);
		end;
		write('> Jumlah yang ingin disetorkan = ');
		readln(Trans.jumlah);
		if not(Trans.jumlah = 0) and (mu <> Trans.mataUang) then
			konversi(Trans.jumlah, mu, Trans.mataUang);
		while (Trans.jumlah < 0) do begin
			writeln('> Jumlah invalid, coba lagi!');
			write('> '); readln(Trans.jumlah);
			if not(Trans.jumlah = 0) and (mu <> Trans.mataUang) then
				konversi(Trans.jumlah, mu, Trans.mataUang);
		end;

		Trans.saldo := Rek.saldo + round(Trans.jumlah);
		Rek.saldo := Trans.saldo;
		Trans.tanggal := currDate;
			
		TabSetorTarik.nEff := TabSetorTarik.nEff + 1;
		TabSetorTarik.setorTarikArray[TabSetorTarik.nEff] := Trans;
		TabRekening.rekeningArray[findIdxRek(TabRekening, Rek.noAkun)].saldo := Rek.saldo;
		writeln('> Transaksi sukses!');
end;

procedure tarik;
{ I.S. TabRekening berisi lebih dari 1}
{ F.S. TabSetorTarik datanya bertambah 1, saldo rekening berkurang}

{ Kamus Lokal }
var
	Rek : TRekening;
	x, mu : string;
	Trans : TSetorTarik;
{ Algoritma }

begin
		pilihRekening(Rek);
		Trans.noAkun := Rek.noAkun;
		Trans.mataUang := Rek.mataUang;
		Trans.saldo := Rek.saldo;
				
		Trans.jenis := 'penarikan';
					
		if (validasiTempo(Rek)) then begin
			writeln('> Diingatkan bahwa mata uang rekening ini adalah ' + Rek.mataUang);
			Trans.jenis := 'penarikan';
			write('> Mata uang jumlah yang ditarikkan = ');
			readln(mu);
			while (mu <> 'IDR') and (mu <> 'USD') and (mu <> 'EUR') do
			begin
				writeln('> Mata uang hanya boleh IDR, USD atau EUR, mohon isi ulang!');
				write('> '); readln(mu);
			end;
			write('> Jumlah yang ingin ditarikkan = ');
			readln(Trans.jumlah);
			if not(Trans.jumlah = 0) then
				konversi(Trans.jumlah, mu, Trans.mataUang);
			while (Trans.jumlah > Rek.saldo) or (Trans.jumlah < 0) do begin
				writeln('> Jumlah invalid, coba lagi!');
				writeln('> Saldo Anda : ', Rek.saldo);
				write('> '); readln(Trans.jumlah);
				if not(Trans.jumlah = 0) then
					konversi(Trans.jumlah, mu, Trans.mataUang);
			end;
			Trans.saldo := Rek.saldo - Trans.jumlah;
			Rek.saldo := Trans.saldo;
			Trans.tanggal := currDate;
			
			TabSetorTarik.nEff := TabSetorTarik.nEff + 1;
			TabSetorTarik.setorTarikArray[TabSetorTarik.nEff] := Trans;
			TabRekening.rekeningArray[findIdxRek(TabRekening, Rek.noAkun)].saldo := Rek.saldo;
			writeln('> Transaksi sukses!');
			end else begin
		writeln('> Transaksi tidak berlangsung!');
	end;
end;

procedure transfer;
{ I.S. : array of TRekening terdefinisi }
{ F.S. : status transfer tertulis pada layar; jika transfer berhasil, saldo rekening dan array of  TTransfer diupdate }

{ Kamus Lokal }
var
	Rek, Rek2 : TRekening;
	Tranf : TTransfer;
	q, x, mu : string;
	biaya : longint;
	
{ Algoritma }
begin
		pilihRekening(Rek);
		Tranf.noAkunDari := Rek.noAkun;
		Tranf.saldo := Rek.saldo;
		Tranf.mataUang := Rek.mataUang;
		if (validasiTempo(Rek)) then
		begin
			writeln('> Pilih jenis transfer : ');
			writeln('> 1. dalam bank');
			writeln('> 2. antar bank');
			write('> '); readln(q); {pilihan}
			while (q <> '1') and (q <> '2') do begin
				writeln('> Masukan salah, Coba lagi!');
				write('> '); readln(q); {pilihan}
			end;
			if (q = '1') then begin
					Tranf.jenis := 'dalam bank'; 
					Tranf.namaBankLuar := '-';
					write('> Masukkan no akun tujuan : ');
					readln(Tranf.noAkunTujuan);
					if (findIdxRek(TabRekening, Tranf.noAkunTujuan) = 0) then
						writeln('> Akun tidak ada dalam bank ini!')
					else
					begin
						Rek2 := TabRekening.rekeningArray[findIdxRek(TabRekening, Tranf.noAkunTujuan)];
						writeln('> Masukkan jumlah uang (dalam ', Rek2.mataUang, ') untuk transfer: ');
						write('> '); readln(Tranf.jumlah);
						if not(Tranf.jumlah = 0) then
								konversi(Tranf.jumlah, Rek2.mataUang, Tranf.mataUang);
						while (Tranf.jumlah > Tranf.saldo) or (Tranf.jumlah < 0) do
						begin
							writeln('> Jumlah transfer tidak valid! Saldo Anda : ', Rek.saldo);
							readln(Tranf.jumlah);
							if not(Tranf.jumlah = 0) then
								konversi(Tranf.jumlah, Rek2.mataUang, Tranf.mataUang);
						end;
						Tranf.saldo := Rek.saldo - Tranf.jumlah;
						if not(Tranf.jumlah = 0) then
							konversi(Tranf.jumlah, Tranf.mataUang, Rek2.mataUang);
						Rek2.saldo := Rek2.saldo + Tranf.jumlah;
						TabRekening.rekeningArray[findIdxRek(TabRekening, Tranf.noAkunTujuan)].saldo := Rek2.saldo;
					end;
			end
			else if (q = '2') then begin
					Tranf.jenis := 'antar bank';
					write('> Masukkan no akun tujuan : ');
					readln(Tranf.noAkunTujuan);
					write('> Masukkan nama bank tujuan : ');
					readln(Tranf.namaBankLuar);
					write('> Masukkan mata uang yang digunakan bank tersebut : ');
					readln(mu);
					if (mu = 'IDR') then begin
						writeln('> Peringatan! Transfer dalam bentuk IDR.');
						writeln('> Biaya administrasi sebesar IDR5.000.');
						write('> Masukkan jumlah yang ingin ditransfer : ');
						readln(Tranf.jumlah);
						biaya := 5000;
						konversi(biaya, mu, Tranf.mataUang);
						if not(Tranf.jumlah = 0) then
							konversi(Tranf.jumlah, mu, Tranf.mataUang);
						while (Tranf.jumlah > Tranf.saldo - biaya) or (Tranf.jumlah < 0) do
						begin
							writeln('> Jumlah transfer tidak valid! Saldo Anda : ', Rek.saldo);
							write('> '); readln(Tranf.jumlah);
							if not(Tranf.jumlah = 0) then
								konversi(Tranf.jumlah, mu, Tranf.mataUang);
						end;
						Tranf.saldo := Rek.saldo - (Tranf.jumlah + biaya);
					end;
					if (mu = 'USD') then begin
						writeln('> Peringatan! Transfer dalam bentuk USD.');
						writeln('> Biaya administrasi sebesar USD2.');
						write('> Masukkan jumlah yang ingin ditransfer : ');
						readln(Tranf.jumlah);
						biaya := 2;
						konversi(biaya, mu, Tranf.mataUang);
						if not(Tranf.jumlah = 0) then
							konversi(Tranf.jumlah, Tranf.mataUang, mu);
						while (Tranf.jumlah > Tranf.saldo - biaya) or (Tranf.jumlah < 0) do
						begin
							writeln('> Jumlah transfer tidak valid! Saldo Anda : ', Rek.saldo);
							write('> '); readln(Tranf.jumlah);
							if not(Tranf.jumlah = 0) then
								konversi(Tranf.jumlah, Tranf.mataUang, mu);
						end;
						Tranf.saldo := Rek.saldo - (Tranf.jumlah + biaya);
					end;
					if (mu = 'EUR') then begin
						writeln('> Peringatan! Transfer dalam bentuk EUR.');
						writeln('> Biaya administrasi sebesar EUR2.');
						write('> Masukkan jumlah yang ingin ditransfer : ');
						write('> '); readln(Tranf.jumlah);
						biaya := 2;
						konversi(biaya, mu, Tranf.mataUang);
						if not(Tranf.jumlah = 0) then
							konversi(Tranf.jumlah, Tranf.mataUang, mu);
						while (Tranf.jumlah > Tranf.saldo - biaya) or (Tranf.jumlah < 0) do
						begin
							writeln('> Jumlah transfer tidak valid! Saldo Anda : ', Rek.saldo);
							readln(Tranf.jumlah);
							if not(Tranf.jumlah = 0) then
								konversi(Tranf.jumlah, Tranf.mataUang, mu);
						end;
						Tranf.saldo := Rek.saldo - (Tranf.jumlah + biaya);
					end;
			end;
			if (q = '2') or not(findIdxRek(TabRekening, Tranf.noAkunTujuan) = 0) then
			begin
				Rek.saldo := Tranf.saldo;
				Tranf.tanggal := currDate;
				
				TabTransfer.nEff := TabTransfer.nEff + 1;
				TabTransfer.transferArray[TabTransfer.nEff] := Tranf;
				TabRekening.rekeningArray[findIdxRek(TabRekening, Rek.noAkun)].saldo := Rek.saldo;
				writeln('> Transfer berhasil!');
			end;
		end
		else
			writeln('> Transfer tak berlangsung!');

end;

(* F10 - F11 oleh Gabriella, dengan berbagai modifikasi pada sumber kode *)

procedure bayar;
{ I.S. : array of TRekening terdefinisi }
{ F.S. : status pembayaran tertulis pada layar; jika pembayaran berhasil, saldo rekening dan array of  TBayar diupdate }

{Karena ada 9 kategori, maka file penuh bila ada 9 data berisi tiap kategori}
{Jika file kosong, diasumsikan nasabah belum berlangganan sebelumnya}

{ Kamus Lokal }
var
	Rek : TRekening;
	Pay : TBayar;
	A, selisih, i : integer;
	denda : boolean = False;
	mu : string;
	Total : longint;
	Dend : integer = 0;
	
{ Algoritma }
Begin
	pilihRekening(Rek);
	Writeln ('> 1. Listrik');
	Writeln ('> 2. PDAM');
	Writeln ('> 3. Telepon');
	Writeln ('> 4. TV kabel');
	Writeln ('> 5. Internet');
	Writeln ('> 6. Kartu kredit');
	Writeln ('> 7. Pajak');
	Writeln ('> 8. Biaya pendidikan');
	Writeln ('> 9. BPJS');
	Write ('> Pilih tujuan pembayaran : ');
	Readln (A);
			
	If (A<1) or (A>9) then
	begin
		Repeat
		Write ('> Pilihan anda salah. Silakan masukkan kembali : ');
		Readln (A);
		until (A>=1) and (A<=8);
	end;
	
	{Validasi sesuai aturan transfer}
	
	Pay.noAkun := Rek.noAkun;
	If A=1 then
		Pay.jenis := 'listrik'
	else if A=2 then
		Pay.jenis := 'PDAM'
	else if A=3 then
		Pay.jenis := 'telepon'
	else if A=4 then
		Pay.jenis := 'TV Kabel'
	else if A=5 then
		Pay.jenis := 'internet'
	else if A=6 then
		Pay.jenis := 'kartu kredit'
	else if A=7 then
		Pay.jenis := 'pajak'
	else if A=8 then
		Pay.jenis := 'biaya pendidikan'
	else
		Pay.jenis := 'BPJS';
	
	i := 1;
	while (i <= TabBayar.nEff) and (TabBayar.bayarArray[i].noAkun <> Rek.noAkun) and (TabBayar.bayarArray[i].jenis = Pay.jenis) do 
	begin
		i := i+1;
	end; 
	if (i > TabBayar.nEff) or not(TabBayar.bayarArray[i].noAkun = Rek.noAkun) or (TabBayar.bayarArray[i].jenis <> Pay.jenis) then 
	begin
		writeln('> Tidak ada data pembayaran sebelumnya.');
		writeln('> ');
	end else
	begin
		selisih := DaysBetween(StrToDate(TabBayar.bayarArray[i].tanggal), Date);
		if(selisih > 30) then
			denda := True;
	end;
	
	Pay.mataUang := Rek.mataUang;
	Write ('> Masukkan nomor Rekening tujuan : ');
	Readln (Pay.rekeningBayar);
	Write ('> Masukkan mata uang pembayaran : ');
	readln(mu);
	Writeln('> Masukkan jumlah pembayaran dalam ', mu,' : ');
	repeat;
		write('> '); Readln (Total);
		if (Total <= 0) then
			writeln('> Masukkan tidak valid! Mohon diulang!');
	until (Total > 0);
	konversi(Total, mu, 'IDR');
	if (denda = True) then
	begin
		Dend := DayOf(Date)-15;
		writeln('> Anda dikenakan denda IDR', Dend*10000);
	end;
	Total := Total + Dend*10000;
	konversi(Total, 'IDR', Pay.mataUang);
	if (Total > Rek.saldo) then
		writeln('> Anda tidak dapat membayar! Saldo Anda : ', Rek.saldo)
	else
	begin
		Pay.jumlah := Total;	
		Pay.saldo := Rek.saldo - Total;
		Pay.tanggal := currDate;
		Rek.saldo := Pay.saldo;

		TabBayar.nEff := TabTransfer.nEff + 1;
		TabBayar.bayarArray[TabBayar.nEff] := Pay;
		TabRekening.rekeningArray[findIdxRek(TabRekening, Rek.noAkun)].saldo := Rek.saldo;
		writeln('> Pembayaran berhasil!');
	end;		
end;

procedure beli;
{ I.S. : array of TRekening terdefinisi }
{ F.S. : status pembelian tertulis pada layar; jika pembelian berhasil, saldo rekening dan array of  TBeli diupdate }

{ Kamus Lokal }
var
	j : integer;
	A : integer;
	Rek : TRekening;
	Buy : TBeli;
{ Algoritma }
Begin
	pilihRekening(Rek);
	For j := 1 to TabBarang.nEff {Jumlah barang dalam list yg bisa dibeli} do
	begin
		Writeln ('> ',j,'. ',TabBarang.barangArray[j].jenis,' | ',TabBarang.barangArray[j].penyedia,' | ', TabBarang.barangArray[j].mataUang, TabBarang.barangArray[j].harga);
		{Ini buat tampilin ke layar, bisa diganti format penulisannya atau mau ga ditulis juga bisa}
	end;
	Write ('> Masukkan pilihan pembelian Anda : ');
	Readln (A);
	
	if (A<1) or (A>TabBarang.nEff) then
	begin
		Repeat
		Write ('> Pilihan anda salah. Silakan masukkan kembali : ');
		Readln (A);
		until (A>=1) and (A<=TabBarang.nEff);
	end;
	
	{Validasi sesuai aturan transfer}
	
	{Validasi saldo dan harga}
	If (Rek.saldo < TabBarang.barangArray[A].harga) then
		Writeln ('> Maaf, saldo Anda tidak mencukupi. Transaksi gagal.')
	else
	begin
		Buy.noAkun := Rek.noAkun;
		Buy.jenis := TabBarang.barangArray[A].jenis;
		Buy.penyedia := TabBarang.barangArray[A].penyedia;
		Write ('> Masukkan nomor rekening tujuan : ');
		Readln (Buy.noTujuan);
		Buy.mataUang := Rek.mataUang;
		Buy.jumlah := TabBarang.barangArray[A].harga;
		if (TabBarang.barangArray[A].mataUang = 'IDR') then
			konversi(Buy.jumlah, 'IDR', Rek.mataUang)
		else if (TabBarang.barangArray[A].mataUang = 'USD') then
			konversi(Buy.jumlah, 'USD', Rek.mataUang)
		else {TabBarang.barangArray[A].mataUang = 'EUR'}
			konversi(Buy.jumlah, 'EUR', Rek.mataUang);
			
		Buy.saldo := Rek.saldo - Buy.jumlah;
		Rek.saldo := Buy.saldo;
		Buy.tanggal := currDate;
		
		TabBeli.nEff := TabBeli.nEff + 1;
		TabBeli.beliArray[TabBeli.nEff] := Buy;
		TabRekening.rekeningArray[findIdxRek(TabRekening, Rek.noAkun)].saldo := Rek.saldo;
		writeln('> Pembelian berhasil!');
	end;
end;

(* F12 - F14 oleh Felix, dengan berbagai modifikasi *)

procedure deleteRekening(i : integer; var rekeningOnlineArray : TTabRekening);
{ I.S. : array of TRekening terdefinisi, indeks array of TRekening dari rekening yang akan dihapus terdefinisi  }
{ F.S. : data satu rekening terhapus dari array of TRekening }

(* ALGORITMA *)
begin
    if i > 0 then
    begin
        rekeningOnlineArray.nEff := rekeningOnlineArray.nEff - 1;
        for i := i to rekeningOnlineArray.Neff do
            rekeningOnlineArray.rekeningArray[i] := rekeningOnlineArray.rekeningArray[i+1];
    end;
end;

procedure tutupRekening();
{ I.S. : array of TRekening terdefinisi  }
{ F.S. : rekening telah ditutup }

(* KAMUS LOKAL *)
const
    Biaya = 25000;
    PenaltiPerHari = 10000;
    BiayaTambahan = 200000;

var
    temp_rekeningOnlineArray : TTabRekening;
	Rek : TRekening;
    input : string;
    i : integer = 0;
    j : integer = 0;
    x : integer;
    waktu, selisih : integer;

(* ALGORITMA *)
begin
    pilihRekening(Rek);
    writeln('> Anda yakin ingin delete file ini? (y/n)');
    write('> '); readln(input);
	while (input <> 'y') and (input <> 'n') do
	begin
		writeln('> Masukan Anda salah, coba lagi!');
		write('> '); readln(input);
	end;
	if (input = 'y') then
	begin	
		if not(validasiTempo(Rek)) then
		begin
			if (Rek.jenis = 'deposito') then
			begin
				waktu := StrToInt(LeftStr(Rek.jangkaWaktu, pos(' ', Rek.jangkaWaktu) - 1)); {dalam bulan}
				selisih := waktu*30 - DaysBetween(StrToDate(Rek.tanggal), Date); {aproksimasi 1 bulan = 30 hari}
				konversi(Rek.saldo, Rek.mataUang, 'IDR');
				if (Rek.saldo < 25000 + 10000*selisih) then
					writeln('> Rekening tidak bisa dihapus, biaya melebihi saldo!');
			end else
			if (Rek.jenis = 'tabungan rencana') then
			begin
				konversi(Rek.saldo, Rek.mataUang, 'IDR');
				if (Rek.saldo < 25000 + 200000) then
					writeln('> Rekening tidak bisa dihapus, biaya melebihi saldo!');
			end else {jenis rekening = tabungan mandiri}
				konversi(Rek.saldo, Rek.mataUang, 'IDR');
				if (Rek.saldo < 25000) then
					writeln('> Rekening tidak bisa dihapus, biaya melebihi saldo!');
		end else
		begin	
		writeln('> Dana:');
		writeln('> 1. Pindahkan ke rekening lain');
		writeln('> 2. Ambil secara tunai');
		write('> '); readln(input);
			repeat
			begin
               if input = '1' then
               begin
                   DeleteRekening(findIdxRek(TabRekening, Rek.noAkun), TabRekening);
                 
                   writeln('> Pilih rekening Anda:');
                   	repeat
						i := i + 1;
						repeat
							j := j + 1;
						until (TabRekening.rekeningArray[j].noNasabah = currNasabah) or (j = TabRekening.nEff);
						if (TabRekening.rekeningArray[j].noNasabah = currNasabah) then
						begin	
							writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
							temp_rekeningOnlineArray.rekeningArray[i] :=  TabRekening.rekeningArray[j];
						end;
					until (j = TabRekening.nEff);
                    write('> '); readln(x);
                    if (x < 1) or (x > TabRekening.nEff) then
						repeat
							writeln('> Ada kesalahan pada input, silakan coba lagi!');
							write('> '); readln(x);
						until (x >= 1) and (x <= i);
					TabRekening.rekeningArray[findIdxRek(TabRekening, temp_rekeningOnlineArray.rekeningArray[x].noAkun)].saldo := TabRekening.rekeningArray[findIdxRek(TabRekening, temp_rekeningOnlineArray.rekeningArray[x].noAkun)].saldo + Rek.saldo;
					writeln('> Penghapusan rekening berhasil!');
               end else
               if input = '2' then
               begin
                   DeleteRekening(findIdxRek(TabRekening, Rek.noAkun), TabRekening);
				writeln('> Penghapusan rekening berhasil!');
               end
               else
               begin
				writeln('> Input tidak valid! Silakan coba lagi!');
				write('> '); readln(input);   
				end;
			end;
            until(input = '1') or (input = '2');       
		end;
	end;
end;

procedure perubahanDataNasabah();
{ I.S. : array of TNasabah terdefinisi }
{ F.S. : data nasabah berubah }

{ Kamus Lokal }
var
	i : integer;
(* ALGORITMA *)
begin
	i:=1;
	while (TabNasabah.nasabahArray[i].noNasabah <> currNasabah) do 
	begin
		i:=i+1;
	end;
    write('> Nama nasabah: '); readln(TabNasabah.nasabahArray[i].nama);
    write('> Alamat: '); readln(TabNasabah.nasabahArray[i].alamat);
    write('> Kota: '); readln(TabNasabah.nasabahArray[i].kota);
    write('> Email: '); readln(TabNasabah.nasabahArray[i].email);
    write('> Nomor Telp: '); readln(TabNasabah.nasabahArray[i].telp);
    write('> Password: '); readln(TabNasabah.nasabahArray[i].pass);
    writeln('> Data nasabah berhasil disimpan!');
end;

procedure penambahanAutoDebet();
{ I.S. : array of TRekening terdefinisi }
{ F.S. : rekening autodebet terdefinisi }

(* KAMUS LOKAL *)
var
	Rek2 : TRekening;
    temp_rekeningOnlineArray : TTabRekening;
    input : integer;
    i, j : integer;
    check : boolean;
    
begin

	i := 0;
	j := 0;
	check := False;
	writeln('> Pilih rekening tabungan rencana atau deposito Anda :');
	repeat
		i := i + 1;
		repeat
			j := j + 1;
		until (not(TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah)) or (j = TabRekening.nEff);
		if not(TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah) then
		begin
			check := True;
			writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
			temp_rekeningOnlineArray.rekeningArray[i] :=  TabRekening.rekeningArray[j];
		end;
	until (j = TabRekening.nEff);
	if not(check) then
		writeln('> Tidak ada tabungan rencana ataupun autodebet!')
	else
	begin
		write('> '); readln(input);
		if (input < 1) or (input > TabRekening.nEff) then
			repeat
				writeln('> Ada kesalahan pada input, silakan coba lagi!');
				write('> '); readln(input);
			until (input >= 1) and (input <= i);
			Rek2 := temp_rekeningOnlineArray.rekeningArray[input];
	end;
	i := 0;
	j := 0;	
	writeln('> Pilih rekening autodebet Anda :');
	repeat
		i := i + 1;
		repeat
			j := j + 1;
		until ((TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah)) or (j = TabRekening.nEff);
		if (TabRekening.rekeningArray[j].jenis = 'tabungan mandiri') and (TabRekening.rekeningArray[j].noNasabah = currNasabah) then
		begin
			writeln('> ', i,'. ', TabRekening.rekeningArray[j].noAkun);
			temp_rekeningOnlineArray.rekeningArray[i] :=  TabRekening.rekeningArray[j];
		end;
	until (j = TabRekening.nEff);
	writeln('> 0. Tidak ada rekening autodebet');
	write('> '); readln(input);
	if (input < 0) or (input > TabRekening.nEff) then
		repeat
			writeln('> Ada kesalahan pada input, silakan coba lagi!');
			write('> '); readln(input);
		until (input >= 0) and (input <= i);
	if (input = 0) then
		Rek2.rekeningAutodebet := '-'
	else
		Rek2.rekeningAutodebet := temp_rekeningOnlineArray.rekeningArray[input].noAkun;
	TabRekening.rekeningArray[findIdxRek(TabRekening, Rek2.noAkun)].rekeningAutodebet := Rek2.rekeningAutodebet;	
end;

procedure exit;
{ I.S. : semua file terdefinisi}
{ F.S. : array of TNasabah, array of TRekening, array of TTransfer, array of TSetorTarik, array of TBayar, array of TBeli telah disalin ke masing-masing file }

{ Kamus Lokal }
var
	i : integer;
	
{ Algoritma }
begin
	rewrite(FBayar);
	for i := 1 to TabBayar.nEff do
		write(FBayar, TabBayar.bayarArray[i]);
	close(FBayar);
	
	rewrite(FBeli);
	for i := 1 to TabBeli.nEff do
		write(FBeli, TabBeli.beliArray[i]);
	close(FBeli);
	
	rewrite(FNasabah);
	for i := 1 to TabNasabah.nEff do
		write(FNasabah, TabNasabah.nasabahArray[i]);
	close(FNasabah);
		
	rewrite(FRekening);
	for i := 1 to TabRekening.nEff do
		write(FRekening, TabRekening.rekeningArray[i]);
	close(FRekening);
	
	rewrite(FSetorTarik);
	for i := 1 to TabSetorTarik.nEff do
		write(FSetorTarik, TabSetorTarik.setorTarikArray[i]);
	close(FSetorTarik);
	
	rewrite(FTransfer);
	for i := 1 to TabTransfer.nEff do
		write(FTransfer, TabTransfer.transferArray[i]);
	close(FTransfer);
end;

begin	
	ShortDateFormat:='dd-mm-yyyy';
	DateSeparator:='-';
	currDate := DateToStr(Date);
end.
