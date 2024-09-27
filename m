Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE26EEAA;
	Fri, 27 Sep 2024 04:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727412223; cv=none; b=FbhSyjtXr1ckwctd6mw9CqhoJvTrjRMH4kitIdYS12GK9ywkSj2wueTC4pL8pNqYjCDQhxT+J3YQYYxAY/8PqzoTfTi9+OLmt5u4Vp+47olmYuVFGVNgGZVcDtkCemJLJdqgCoLBFsn/yK7jM3N2HuRBKCPFRSoNzF2Bh0tE8II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727412223; c=relaxed/simple;
	bh=ByaiicKVIThiZVPaQYbkTecdV1bI7Sr8jIOZ/q1Rx78=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To; b=DglMhEh2UuLOaIl6MWqMa5YpIb32Ukovpl1Ba/T1naOTGXDUF8y6lAJrVgKU/YgCmpbgdjuxHobHWf3nZZ4H17e3beWY4oZ9GmWHACUjZ6y59vxRNnGytolg7FHoMLNVirju30OYAlXeqpNuW9sE3oOZ29U0kGDfSnCEgKWNJRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 0ac2c5d87c8b11efa216b1d71e6e1362-20240927
X-QC-Scan-Result: 0
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:170fd357-4e12-438f-bf6b-1238ab00fe94,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:5,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.1.38,REQID:170fd357-4e12-438f-bf6b-1238ab00fe94,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:5,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:82c5f88,CLOUDID:8a7a1a8e225fcd64647c8622551f765e,BulkI
	D:240927124331T9E8EBRU,BulkQuantity:0,Recheck:0,SF:74|66|23|17|19|43|102,T
	C:nil,Content:4|-5,EDM:-3,IP:-2,URL:1,File:2,RT:nil,Bulk:nil,QS:0,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: 0ac2c5d87c8b11efa216b1d71e6e1362-20240927
X-User: zhaomengmeng@kylinos.cn
Received: from [192.168.109.86] [(123.149.251.210)] by mailgw.kylinos.cn
	(envelope-from <zhaomengmeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 610910333; Fri, 27 Sep 2024 12:43:29 +0800
Content-Type: multipart/mixed; boundary="------------yGOcBU3MX03yCSqoIDsBuSOd"
Message-ID: <a2f49743-4617-4655-ab4e-d94928368647@kylinos.cn>
Date: Fri, 27 Sep 2024 12:43:25 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_stripe_to_text
From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
In-Reply-To: <66f4dcd2.050a0220.211276.003a.GAE@google.com>

This is a multi-part message in MIME format.
--------------yGOcBU3MX03yCSqoIDsBuSOd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1ec6d097897a
--------------yGOcBU3MX03yCSqoIDsBuSOd
Content-Type: text/x-patch; charset=UTF-8; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2JjYWNoZWZzL2VjLmMgYi9mcy9iY2FjaGVmcy9lYy5jCmluZGV4
IDE0MWE0YzYzMTQyZi4uMmQ1Y2Q5ZDgzN2YyIDEwMDY0NAotLS0gYS9mcy9iY2FjaGVmcy9l
Yy5jCisrKyBiL2ZzL2JjYWNoZWZzL2VjLmMKQEAgLTE0NCw3ICsxNDQsNyBAQCB2b2lkIGJj
aDJfc3RyaXBlX3RvX3RleHQoc3RydWN0IHByaW50YnVmICpvdXQsIHN0cnVjdCBiY2hfZnMg
KmMsCiAJCSAgIG5yX2RhdGEsCiAJCSAgIHMubnJfcmVkdW5kYW50KTsKIAliY2gyX3BydF9j
c3VtX3R5cGUob3V0LCBzLmNzdW1fdHlwZSk7Ci0JcHJ0X3ByaW50ZihvdXQsICIgZ3JhbiAl
dSIsIDFVIDw8IHMuY3N1bV9ncmFudWxhcml0eV9iaXRzKTsKKwlwcnRfcHJpbnRmKG91dCwg
IiBncmFuIDE8PCV1Iiwgcy5jc3VtX2dyYW51bGFyaXR5X2JpdHMpOwogCiAJZm9yICh1bnNp
Z25lZCBpID0gMDsgaSA8IHMubnJfYmxvY2tzOyBpKyspIHsKIAkJY29uc3Qgc3RydWN0IGJj
aF9leHRlbnRfcHRyICpwdHIgPSBzcC0+cHRycyArIGk7Cg==

--------------yGOcBU3MX03yCSqoIDsBuSOd--
