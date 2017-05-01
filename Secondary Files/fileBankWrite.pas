Program fileMake;
uses datVariables, sysutils;
var
	bar : TBarang;
	byr : TBayar;
	bel : TBeli;
	mu : TMataUang;
	nas : TNasabah;
	rek : TRekening;
	st : TSetorTarik;
	trs : TTransfer;
	
	s : string;
	n : integer;
	i : integer;
	
begin
	write('Input nama file barang: ');
	readln(s);
	assign(FBarang, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FBarang);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(bar.jenis);
		readln(bar.penyedia);
		readln(bar.mataUang);
		readln(bar.harga);
		write(FBarang, bar);
	end;
	close(FBarang);
		write('Input nama file bayar: ');
	readln(s);
	assign(FBayar, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FBayar);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(byr.noAkun);
		readln(byr.jenis);
		readln(byr.rekeningBayar);
		readln(byr.mataUang);
		readln(byr.jumlah);
		readln(byr.saldo);
		readln(byr.tanggal);
		write(FBayar, byr);
	end;
	close(FBayar);
		write('Input nama file beli (maksimum 9): ');
	readln(s);
	assign(FBeli, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FBeli);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(bel.noAkun);
		readln(bel.jenis);
		readln(bel.penyedia);
		readln(bel.noTujuan);
		readln(bel.mataUang);
		readln(bel.jumlah);
		readln(bel.saldo);
		readln(bel.tanggal);
		write(FBeli, bel);
	end;
	close(FBeli);
		write('Input nama file mata uang: ');
	readln(s);
	assign(FMataUang, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FMataUang);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(mu.nilaiKursDari);
		readln(mu.kursDari);
		readln(mu.nilaiKursTujuan);
		readln(mu.kursTujuan);
		write(FMataUang, mu);
	end;
	close(FMataUang);
		write('Input nama file nasabah (maksimum 2): ');
	readln(s);
	assign(FNasabah, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FNasabah);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(nas.noNasabah);
		readln(nas.nama);
		readln(nas.alamat);
		readln(nas.kota);
		readln(nas.email);
		readln(nas.telp);
		readln(nas.user);
		readln(nas.pass);
		readln(nas.status);
		write(FNasabah, nas);
	end;
	close(FNasabah);
		write('Input nama file rekening: ');
	readln(s);
	assign(FRekening, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FRekening);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(rek.noAkun);
		readln(rek.noNasabah);
		readln(rek.jenis);
		readln(rek.mataUang);
		readln(rek.saldo);
		readln(rek.setoranRutin);
		readln(rek.rekeningAutodebet);
		readln(rek.jangkawaktu);
		readln(rek.tanggal);
		write(FRekening, rek);
	end;
	close(FRekening);
		write('Input nama file setor tarik: ');
	readln(s);
	assign(FSetorTarik, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FSetorTarik);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(st.noAkun);
		readln(st.jenis);
		readln(st.mataUang);
		readln(st.jumlah);
		readln(st.saldo);
		readln(st.tanggal);
		write(FSetorTarik, st);
	end;
	close(FSetorTarik);
		write('Input nama file transfer: ');
	readln(s);
	assign(FTransfer, s);
	write('Input jumlah data: ');
	readln(n);
	rewrite(FTransfer);
	i := 1;
	while (i <= n) do
	begin
		i := i + 1;
		readln(trs.noAkunDari);
		readln(trs.noAkunTujuan);
		readln(trs.jenis);
		readln(trs.namaBankLuar);
		readln(trs.mataUang);
		readln(trs.jumlah);
		readln(trs.saldo);
		readln(trs.tanggal);
		write(FTransfer, trs);
	end;
	close(FTransfer);
end.
