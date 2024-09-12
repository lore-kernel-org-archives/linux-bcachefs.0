Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D73B3C6AC;
	Thu, 12 Sep 2024 02:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726108813; cv=none; b=D2Ms4Btz18qKRT/G3ze9GHj1sHbKEno/6+nF2No+kg6gNZI0cr1zfZqz3BIDHft1vNdzW5cbNE5JuSQA5Y/TYVSLIH4Q3xIK5cd+HIIX+MJObOEYJP1ANI2F1qpdqmTkiZs0aaI/7Hdq2ge0X4pNOUXFh7gl/08Sxuj2/Vpo5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726108813; c=relaxed/simple;
	bh=n9zPdd6VyObY2XyYje8KfAAclPbnHAcROpIDVThF3+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=GziD1TmKRJRsRqICSjcdkNoAS5GDBldv+OFq/0ToawNMqkuGSD7F6BoLYKpLk/r23t/uu2kkkrac1QAcAg+c4GMSY7oTCGLA+5IS0m5NJmiC4jm3S8ai9LAcLtvas/vdcOTtVNZou74roJ6otiZABoSZtb+oaNpY8HWcY9Wr/yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=fail (1024-bit key) header.d=163.com header.i=@163.com header.b=EQd4CRSj reason="signature verification failed"; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=163.com header.i=@163.com header.b="EQd4CRSj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:Subject:Content-Type:MIME-Version:
	Message-ID; bh=rrePD99XD6KgiMnMr0Ra2sNyjZivH58JwfIFtEA4/Z8=; b=E
	Qd4CRSjXpgRuQUpCPr63VFL7vnsjVZZ12iWfDs5LpGCgcG3s67//8+jBoVcXeONg
	dKdzm7b12QK8+G2cqoHimCgNNIHFtCwVlXgDAaZxGWwmZItekFjmxF2Pssjo8SXq
	tWeCIJQ45Cv1rVwGrqiL6rZmnwFPLQu+bGckNBCQ+A=
Received: from 00107082$163.com ( [111.35.191.143] ) by
 ajax-webmail-wmsvr-40-144 (Coremail) ; Thu, 12 Sep 2024 10:39:48 +0800
 (CST)
Date: Thu, 12 Sep 2024 10:39:48 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG?] bcachefs performance: read is way too slow when a file
 has no overwrite.
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20240801(9da12a7b)
 Copyright (c) 2002-2024 www.mailtech.cn 163com
In-Reply-To: <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
References: <ka3sjrka6dugdaab2bvewfbonc3ksixumue3hs2juhajhjm37w@bnxvz5mozpgr>
 <20240907103437.71139-1-00107082@163.com>
 <ebqvaqme76nrgr2dh7avy7yjwxsgnnybxuybgxejahupgbrqw5@a6d244ghjqis>
X-NTES-SC: AL_Qu2ZBP2bt08j7iOYZ+kXn0oTju85XMCzuv8j3YJeN500tSbm6C8rRHh6JVzw3OSLFiCJtx+lbD9ezNRZZK9cdrlWYK4/K7ewwMY1LvZbmBJ6
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <f69544.2e70.191e419e656.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:_____wDXPzl1VOJmJqwCAA--.777W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/1tbiMxVYqmXAnzbDTQADsV
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

CkhpLCAKQXQgMjAyNC0wOS0wOSAyMTozNzozNSwgIktlbnQgT3ZlcnN0cmVldCIgPGtlbnQub3Zl
cnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOgo+T24gU2F0LCBTZXAgMDcsIDIwMjQgYXQgMDY6MzQ6
MzdQTSBHTVQsIERhdmlkIFdhbmcgd3JvdGU6Cgo+PiAKPj4gQmFzZWQgb24gdGhlIHJlc3VsdDoK
Pj4gMS4gVGhlIHJvdyB3aXRoIHByZXBhcmUtd3JpdGUgc2l6ZSA0SyBzdGFuZHMgb3V0LCBoZXJl
Lgo+PiBXaGVuIGZpbGVzIHdlcmUgcHJlcGFpcmVkIHdpdGggd3JpdGUgc2l6ZSA0SywgdGhlIGFm
dGVyd2FyZHMKPj4gIHJlYWQgcGVyZm9ybWFuY2UgaXMgd29yc2UuICAoSSBkaWQgZG91YmxlIGNo
ZWNrIHRoZSByZXN1bHQsCj4+IGJ1dCBpdCBpcyBwb3NzaWJsZSB0aGF0IEkgbWlzcyBzb21lIGFm
ZmVjdGluZyBmYWN0b3JzLik7Cj4KPk9uIHNtYWxsIGJsb2Nrc2l6ZSB0ZXN0cyB5b3Ugc2hvdWxk
IGJlIGxvb2tpbmcgYXQgSU9QUywgbm90IE1CL3MuCj4KPlByZXBhcmUtd3JpdGUgc2l6ZSBpcyB0
aGUgY29sdW1uPwpFYWNoIHJvdyBpcyBmb3IgYSBzcGVjaWZpYyBwcmVwYXJlLXdyaXRlIHNpemUg
aW5kaWNhdGVkIGJ5IGZpcnN0IGNvbHVtbi4gCgo+Cj5Bbm90aGVyIGZhY3RvciBpcyB0aGF0IHdl
IGRvIG1lcmdlIGV4dGVudHMgKGluY2x1ZGluZyBjaGVja3N1bXMpOyBzbyBpZgo+dGhlIHByZXBh
cmV0LXdyaXRlIGlzIGRvbmUgc2VxdWVudGlhbGx5IHdlIHdvbid0IGFjdHVhbGx5IGJlIGVuZGlu
ZyB1cAo+d2l0aCBleHRlbnRzIG9mIHRoZSBzYW1lIHNpemUgYXMgd2hhdCB3ZSB3cm90ZS4KPgo+
SSBiZWxpZXZlIHRoZXJlJ3MgYSBrbm9iIHNvbWV3aGVyZSB0byB0dXJuIG9mZiBleHRlbnQgbWVy
Z2luZyAobW9kdWxlCj5wYXJhbWV0ZXI/IGl0J3MgaW50ZW5kZWQgZm9yIGRlYnVnZ2luZykuCgpJ
IG1hZGUgc29tZSBkZWJ1Zywgd2hlbiBwZXJmb3JtYW5jZSBpcyBiYWQsIHRoZSBjb25kaXRpb25z
CmJ2ZWNfaXRlcl9zZWN0b3JzKGl0ZXIpICE9IHBpY2suY3JjLnVuY29tcHJlc3NlZF9zaXplIGFu
ZCAKYnZlY19pdGVyX3NlY3RvcnMoaXRlcikgIT0gcGljay5jcmMubGl2ZV9zaXplIGFyZSAiYWxt
b3N0IiBhbHdheXMgYm90aCAidHJ1ZSIsCndoaWxlIHdoZW4gcGVyZm9ybWFuY2UgaXMgZ29vZCAo
YWZ0ZXIgInRob3JvdWdoIiB3cml0ZSksIHRoZXkgYXJlIG9ubHkgbGl0dGxlCnBlcmNlbnQgKH4z
NTAgb3V0IG9mIDEwMDAwMDApICB0byBiZSB0cnVlLgoKQW5kIGlmIHRob3NlIGNvbmRpdGlvbnMg
YXJlICJ0cnVlIiwgImJvdW5jZSIgd291bGQgYmUgc2V0IGFuZCBjb2RlIHNlZW1zIHRvIHJ1bgpv
biBhIHRpbWUgY29uc3VtaW5nIHBhdGguCgpJIHN1c3BlY3QgIm1lcmVseSByZWFkIiBjb3VsZCBu
ZXZlciBjaGFuZ2UgdGhvc2UgY29uZGl0aW9ucywgYnV0ICJ3cml0ZSIgY2FuPwoKPgo+PiAyLiBX
aXRob3V0IE9fRElSRUNULCByZWFkIHBlcmZvcm1hbmNlIHNlZW1zIGNvcnJlbGF0ZWQgd2l0aCB0
aGUgZGlmZmVyZW5jZQo+PiAgYmV0d2VlbiByZWFkIHNpemUgYW5kIHByZXBhcmUgd3JpdGUgc2l6
ZSwgYnV0IHdpdGggT19ESVJFQ1QsIGNvcnJlbGF0aW9uIGlzIG5vdCBvYnZpb3VzLgo+Cj5TbyB0
aGUgT19ESVJFQ1QgYW5kIGJ1ZmZlcmVkIElPIHBhdGhzIGFyZSB2ZXJ5IGRpZmZlcmVudCAoaW4g
ZXZlcnkKPmZpbGVzeXN0ZW0pIC0geW91J3JlIGxvb2tpbmcgYXQgdmVyeSBkaWZmZXJlbnQgdGhp
bmdzLiBUaGV5IGFyZSBib3RoCj5zdWJqZWN0IHRvIHRoZSBjaGVja3N1bSBncmFudWxhcml0eSBp
c3N1ZSwgYnV0IGluIGJ1ZmZlcmVkIG1vZGUgd2Ugcm91bmQKPnVwIHJlYWRzIHRvIGV4dGVudCBz
aXplLCB3aGVuIGZpbGxpbmcgaW50byB0aGUgcGFnZSBjYWNoZS4KPgo+QmlnIHN0YW5kYXJkIGRl
dmlhdGlvbiAoaGlnaCB0YWlsIGxhdGVuY3k/KSBpcyBzb21ldGhpbmcgd2UnZCB3YW50IHRvCj50
cmFjayBkb3duLiBUaGVyZSdzIGEgYnVuY2ggb2YgdGltZV9zdGF0cyBpbiBzeXNmcywgYnV0IHRo
ZXkncmUgbW9zdGx5Cj5mb3IgdGhlIHdyaXRlIHBhdGhzLiBJZiB5b3UncmUgdHJ5aW5nIHRvIGlk
ZW50aWZ5IHdoZXJlIHRoZSBsYXRlbmNpZXMKPmFyZSBjb21pbmcgZnJvbSwgd2UgY2FuIGxvb2sg
YXQgYWRkaW5nIHNvbWUgbmV3IHRpbWUgc3RhdHMgdG8gaXNvbGF0ZS4K
