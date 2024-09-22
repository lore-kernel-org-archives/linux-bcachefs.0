Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69645192B84;
	Sun, 22 Sep 2024 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726969176; cv=none; b=Y7M2LKCv0D0va/YMdmWchMF54MpdMN/IGt+aFkr31iSKGFmkxhQgrAXJ9z0MsAPFXzFsXm+O7CymvDDSIWcdG0CG6dG4vXVdQk0bOPYgixxqDE41So96xfO3wnio1Xe+IQ5cgKDVtt3nVaWkCovemQ3tIoEfY5vL1FTCpgzj6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726969176; c=relaxed/simple;
	bh=/CB0pbJTt5AxdFF4FVnla8ZJPR5ccRumczUHLSvyq3E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=L1IELRUYdaqLAJc5wZqkkGcGkvrvYF8gep0zGRZHvC3G92qZ+Z+gIDjhzGqKgmQ7cdFyaSYx0o7W0xPG7Am42HK0Cv78UCmGQhFoEJw3dUTjwW93svrMjZbcV+E1kvcBL3z7Ppni06pGCucbfquUnT4KQM/WWjuodn5zSA2T26E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=V2wtZrPg reason="signature verification failed"; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="V2wtZrPg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=5IsNAlKLM0kNqMNoH8sJdkmxMHDYlo7/74w7aM1lxj8=; b=V
	2wtZrPgeJ1fvA9U3iVGBdDCriXWfqXY2uem8Y5M87wSX6MsOo9FH4yfVpWtE/RG4
	5BlFt12epyM7PQ2CKCVGq4teli7j/8xATA0lhiefois10yA/o6tBUAhGORLnNaEP
	BK6Y5OQT5CVz3tVF0FHwqgwDf87FESY3jCMy3zmi1U=
Received: from 00107082$163.com ( [111.35.191.143] ) by
 ajax-webmail-wmsvr-40-130 (Coremail) ; Sun, 22 Sep 2024 09:39:18 +0800
 (CST)
Date: Sun, 22 Sep 2024 09:39:18 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite.
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20240801(9da12a7b)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <p4kifs3bwqe2ibq5ezx26c6jse7cjtkourlmkectx4sznrpqjk@ncvqp7rqjt6v>
References: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
 <20240907103437.71139-1-00107082@163.com>
 <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
 <531cddb2.430d.1921551ada4.Coremail.00107082@163.com>
 <p4kifs3bwqe2ibq5ezx26c6jse7cjtkourlmkectx4sznrpqjk@ncvqp7rqjt6v>
X-NTES-SC: AL_Qu2ZBPWdtkku7ieZbOkZnEYQheY4XMKyuPkg1YJXOp80mCXC8wkabG5cI1rK9fmDMiSmoQm1UCZS1OVje4xTc5hYDN+4hhIik5xi0rDHRTg6
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <79f17c7a.65f.19217621c47.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:gigvCgD3H5tHde9m9XgBAA--.14383W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbB0gliqmWX0j8wDwAEs3
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

SGksIAoKQXQgMjAyNC0wOS0yMiAwMDoxMjowMSwgIktlbnQgT3ZlcnN0cmVldCIgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOgo+T24gU3VuLCBTZXAgMjIsIDIwMjQgYXQgMTI6MDI6
MDdBTSBHTVQsIERhdmlkIFdhbmcgd3JvdGU6Cj4+IEhpLCAKPj4gCj4+IEF0IDIwMjQtMDktMDkg
MjE6Mzc6MzUsICJLZW50IE92ZXJzdHJlZXQiIDxrZW50Lm92ZXJzdHJlZXRAbGludXguZGV2PiB3
cm90ZToKPj4gPk9uIFNhdCwgU2VwIDA3LCAyMDI0IGF0IDA2OjM0OjM3UE0gR01ULCBEYXZpZCBX
YW5nIHdyb3RlOgo+PiAKPj4gPgo+PiA+QmlnIHN0YW5kYXJkIGRldmlhdGlvbiAoaGlnaCB0YWls
IGxhdGVuY3k/KSBpcyBzb21ldGhpbmcgd2UnZCB3YW50IHRvCj4+ID50cmFjayBkb3duLiBUaGVy
ZSdzIGEgYnVuY2ggb2YgdGltZV9zdGF0cyBpbiBzeXNmcywgYnV0IHRoZXkncmUgbW9zdGx5Cj4+
ID5mb3IgdGhlIHdyaXRlIHBhdGhzLiBJZiB5b3UncmUgdHJ5aW5nIHRvIGlkZW50aWZ5IHdoZXJl
IHRoZSBsYXRlbmNpZXMKPj4gPmFyZSBjb21pbmcgZnJvbSwgd2UgY2FuIGxvb2sgYXQgYWRkaW5n
IHNvbWUgbmV3IHRpbWUgc3RhdHMgdG8gaXNvbGF0ZS4KPj4gCj4+IEFib3V0IHBlcmZvcm1hbmNl
LCBJIGhhdmUgYSB0aGVvcnkgYmFzZWQgb24gc29tZSBvYnNlcnZhdGlvbiBJIG1hZGUgcmVjZW50
bHk6Cj4+IFdoZW4gdXNlciBzcGFjZSBhcHAgbWFrZSBhIDRrKDggc2VjdG9ycykgZGlyZWN0IHdy
aXRlLCAKPj4gYmNhY2hlZnMgd291bGQgaW5pdGlhdGUgYSB3cml0ZSByZXF1ZXN0IG9mIH4xMSBz
ZWN0b3JzLCBpbmNsdWRpbmcgdGhlIGNoZWNrc3VtIGRhdGEsIHJpZ2h0Pwo+PiBUaGlzIG1heSBu
b3QgYmUgYSBnb29kIG9mZnNldCtzaXplIHBhdHRlcm4gb2YgYmxvY2sgbGF5ZXIgZm9yIHBlcmZv
cm1hbmNlLiAgCj4+IChJIGRpZCBnZXQgYSB2ZXJ5LXZlcnkgYmFkIHBlcmZvcm1hbmNlIG9uIGV4
dDQgaWYgd3JpdGUgd2l0aCA1SyBzaXplLikKPgo+VGhlIGNoZWNrc3VtIGlzbid0IGlubGluZSB3
aXRoIHRoZSBkYXRhLCBpdCdzIHN0b3JlZCB3aXRoIHRoZSBwb2ludGVyIC0KPnNvIGlmIHlvdSdy
ZSBzZWVpbmcgMTEgc2VjdG9yIHdyaXRlcywgc29tZXRoaW5nIHJlYWxseSBvZGQgaXMgZ29pbmcK
Pm9uLi4uCj4KCi4uLi4gVGhpcyBpcyByZWFsbHkgY29udHJhZGljdCB3aXRoIG15IG9ic2VydmF0
aW9uOgoxLiBmaW8gc3RhdHMgeWllbGRzIGEgYXZlcmFnZSA1MEsgSU9QUyBmb3IgYSA0MDAgc2Vj
b25kcyByYW5kb20gZGlyZWN0IHdyaXRlIHRlc3QuCjIuIGZyb20gL3Byb2MvZGlza3N0YXRhcywg
YXZlcmFnZSAiRmllbGQgNSAtLSAjIG9mIHdyaXRlcyBjb21wbGV0ZWQiICBwZXIgc2Vjb25kIGlz
IGFsc28gNTBLCihIZXJlIEkgY29uY2x1ZGUgdGhlIHBlcmZvcm1hbmNlIGlzc3VlIGlzIG5vdCBj
YXVzZWQgYnkgZXh0cmEgSU9QUyBmb3IgY2hlY2tzdW0uKQozLiAgZnJvbSAiRmllbGQgMTAgLS0g
IyBvZiBtaWxsaXNlY29uZHMgc3BlbnQgZG9pbmcgSS9PcyIsICBhdmVyYWdlIGRpc2sgImJ1c3ki
IHRpbWUgcGVyIHNlY29uZCBpcyBhYm91dCB+MC45c2Vjb25kLCBzaW1pbGFyIHRvIHRoZSByZXN1
bHQgb2YgZXh0NCB0ZXN0LgooSGVyZSBJIGNvbmNsdWRlIHRoZSBwZXJmb3JtYW5jZSBpc3N1ZSBp
dCBub3QgY2F1c2VkIGJ5IG5vdCBwdXNoaW5nIGRpc2sgZGV2aWNlIHRvbyBoYXJkLikKNC4gZGVs
dGEoRmllbGQgNyAtLSAjIG9mIHNlY3RvcnMgd3JpdHRlbikgLyBkZWx0YShGaWVsZCA1IC0tICMg
b2Ygd3JpdGVzIGNvbXBsZXRlZCkgIGZvciA1IG1pbnV0ZXMgaW50ZXJ2YWwgaXMgMTEgc2VjdG9y
cy93cml0ZS4KKFRoaXMgaXMgd2h5IEkgZHJhdyB0aGUgdGhlb3J5IHRoYXQgdGhlIGNoZWNrc3Vt
IGlzIHdpdGggcmF3IGRhdGEuLi4uLi5JIHRob3VnaHQgaXMgd2FzIGEgcmVhc29uYWJsZS4uLikK
Ckkgd2lsbCBtYWtlIHNvbWUgZGVidWcgY29kZSB0byBjb2xsZWN0IHNlY3RvciBudW1iZXIgcGF0
dGVybnMuCgogCgoKPkkgd291bGQgc3VnZ2VzdCBkb2luZyBzb21lIHRlc3Rpbmcgd2l0aCBkYXRh
IGNoZWNrc3VtcyBvZmYgZmlyc3QsIHRvCj5pc29sYXRlIHRoZSBpc3N1ZTsgdGhlbiBpdCBzb3Vu
ZHMgbGlrZSB0aGF0IElPIHBhdHRlcm4gbmVlZHMgdG8gYmUKPmxvb2tlZCBhdC4KCkkgd2lsbCB0
cnkgaXQuIAogCj4KPkNoZWNrIHRoZSBleHRlbnRzIGJ0cmVlIGluIGRlYnVnZnMgYXMgd2VsbCwg
dG8gbWFrZSBzdXJlIHRoZSBleHRlbnRzIGFyZQo+Z2V0dGluZyB3cml0dGVuIG91dCBhcyB5b3Ug
dGhpbmsgdGhleSBhcmUuCgoKClRoYW5rcwpEYXZpZAo=
