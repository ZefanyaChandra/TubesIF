(* Program ini dibuat oleh Kelompok 12 Kelas 04*)

Program bank;
uses datVariables, commands, crt;
{Program ini bertujuan sebagai suatu model sederhana yang
 mensimulasikan cara kerja bank}
{Dalam program ini digunakan type uang berupa longint dan bukan float, sehingga
 tidak akan akurat untuk jumlah bernilai kecil}
 
{ Kamus }

var
	command : string; {perintah yang dimasukkan}
	loaded : boolean; {fungsi load hanya boleh dijalankan sekali untuk mencegah error}
	logged : boolean = False; {penanda sudah login atau belum}
	
	{F1 - F15}
procedure cLoad;
(* Menyiapkan segala file yang diperlukan dan menyimpannya ke suatu array *)
begin
	if (loaded) then
		writeln('> Anda hanya boleh load file satu kali! Jika ingin load ulang, restart program.')
	else
	begin
		load;
		loaded := True;
	end;
end;

procedure cLogin;

begin
	if (logged = False) then
		login(TabNasabah, currNasabah, logged)
	else
	begin
		writeln('> Anda telah di-logout!');
		logged := False;
		login(TabNasabah, currNasabah, logged);
	end;
end;

procedure cLihatRekening;

begin
	if (logged = True) then
	begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else
			tulisRek(TabRekening, currNasabah);
	end
	else
		writeln('> Anda belum login!');
end;

procedure cInfoSaldo;

begin
	if (logged = True) then
		lihatSaldo(TabRekening)
	else
		writeln('> Anda belum login!');
end;
				
procedure cLihatAktivitasTransaksi;

begin
	if (logged = True) then
		lihatAktivitas(tabRekening, TabSetorTarik, TabTransfer, TabBayar, TabBeli)
	else
		writeln('> Anda belum login!');
end;

procedure cBuatRekening;

begin
	if (logged = True) then
	begin
		if (TabRekening.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa menambah rekening lagi.')
		else
			buatRekening;
	end
	else
		writeln('> Anda belum login!');

end;

procedure cSetor;

begin
	if (logged = True) then
	begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else if (TabSetorTarik.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa membuat transaksi lagi.')
		else
			setor;
	end
	else
		writeln('> Anda belum login!');

end;

procedure cTarik;

begin
	if (logged = True) then
		begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else if (TabSetorTarik.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa membuat transaksi lagi.')
		else
			tarik;
	end
	else
		writeln('> Anda belum login!');

end;

procedure cTransfer;

begin
	if (logged = True) then
		begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else if (TabTransfer.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa melakukan transfer lagi.')
		else
			transfer;
	end	
	else
		writeln('> Anda belum login!');
end;

procedure cBayar;

begin
	if (logged = True) then
		begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else if (TabBayar.nEff = 0) then
		begin
			writeln('> Tidak ada data pembayaran.');
			writeln('> Jika tidak ada data maka tidak ada denda.');
		end
		else if (TabBayar.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa melakukan pembayaran lagi.')
		else
			bayar;
		end
	else
		writeln('> Anda belum login!');
end;

procedure cBeli;

begin
	if (logged = True) then
		begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else if (TabBarang.nEff = 0) then
		begin
			writeln('> Tidak ada yang bisa dibeli!');
		end
		else if (TabBeli.nEff = NMax) then
			writeln('> File sudah penuh! Tidak bisa melakukan pembelian lagi.')
		else
			beli;
		end
	else
		writeln('> Anda belum login!');
end;

procedure cTutupRekening;

begin
	if (logged = True) then
	begin
		if (TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening!')
		else
			tutupRekening;
	end
	else
		writeln('> Anda belum login!');
end;

procedure cUbahData;

begin
	if (logged = True) then
		perubahanDataNasabah()
	else
		writeln('> Anda belum login!');
end;

procedure cTambahAutodebet;

begin
	if (logged = True) then
	begin
		if(TabRekening.nEff = 0) then
			writeln('> Tidak ada rekening. Anda dapat membuat rekening baru.')
		else
			penambahanAutoDebet();
	end
	else
		writeln('> Anda belum login!');
end;

procedure cExit;

begin
	if (logged = True) then
		exit;
end;

procedure cHelp;

begin
	writeln('> Inilah list command yang bisa dipakai pada program ini: ');
	writeln('> load');
	writeln('> login');
	writeln('> lihat rekening');
	writeln('> informasi saldo');
	writeln('> sejarah transaksi');
	writeln('> buat rekening');
	writeln('> setor');
	writeln('> tarik');
	writeln('> transfer');
	writeln('> bayar');
	writeln('> beli');
	writeln('> tutup rekening');
	writeln('> ubah data');
	writeln('> tambah autodebet');
	writeln('> exit');
	writeln('> clear');
	writeln('> help');
	writeln('> ');
end;

{ Algoritma }	
begin
	loaded := False;
	writeln('Selamat datang ke dalam program simulasi bank!');
	writeln('Disediakan command khusus berupa "help" untuk bantuan.');
	writeln;
	writeln('Tekan Enter untuk menjalankan program.');
	writeln('Tip: load file dulu dan login agar fitur lain dapat diakses.');
	readln;
	clrscr;
	repeat
		write('> ');
		readln(command);
		case command of
			'load' : cLoad;
			'login' : cLogin;
			'lihat rekening' : cLihatRekening;
			'informasi saldo' : cInfoSaldo;
			'sejarah transaksi' : cLihatAktivitasTransaksi;
			'buat rekening' : cBuatRekening;
			'setor' : cSetor;
			'tarik' : cTarik;
			'transfer' : cTransfer;
			'bayar' : cBayar;
			'beli' : cBeli;
			'tutup rekening' : cTutupRekening;
			'ubah data' : cUbahData;
			'tambah autodebet' : cTambahAutodebet;
			'exit' : cExit;
			'clear' : clrscr;
			'help' : cHelp;
			else
				writeln('> Command tidak dikenal.');
		end;
		writeln('> ');
	until(command = 'exit');
end.
