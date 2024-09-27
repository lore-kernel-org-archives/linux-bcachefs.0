Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D68616D4E5;
	Fri, 27 Sep 2024 02:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727405650; cv=none; b=D27wlZDaTkkuFnBEtHle0B0Dmsage/XSUXrjbZWwvhkulBJqbJKpkULfzZCVOgJIHzEkp0rX493IRBXHGMNCC8Q5/GyW7lsiFCfIRsjYCD5tFsXyLESDEztMPrv6TLSYJUKhklBmDiibQhyHde7qWuD5oRGAjzrkM7Dtb574c/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727405650; c=relaxed/simple;
	bh=deZe+N4U+auJ8F5+Irr8j62mvltmBrklrtHWPecmQT8=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To; b=tBHPzcxek9HrFY2UdIMuZKFIMuHjeQc92ER5Sa+q2xuwhG3sbo4Vli0ADcoXBQ7kT5CLQtJGhA4QkwnG1AvXwL4EWlA05rgE8Z/dBS4WocQEJllHQ8J0K87U82KNeUocGcsOVsdos+D3ZLNWqPrkkuFee+99a+pKE1vvF++uros=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=JP+Md7IL; arc=none smtp.client-ip=220.197.31.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="JP+Md7IL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Content-Type:Message-ID:Date:MIME-Version:Subject:
	From; bh=deZe+N4U+auJ8F5+Irr8j62mvltmBrklrtHWPecmQT8=; b=JP+Md7I
	LbT0TQ5JXKQrGbsnz6HTWFBEaFLMXj9Kl7mxkkwnJUEi+eaMTpZ57rtMiSV6CKHz
	dm7Sf29bAj/dTT98KrGWrR0RvtEa9V+mDUVfrR4zW2VZYbelkSH1V9HPJHHpRDDj
	O5tov1kOWEuN/+CpEbk0dDhtV1Kkop5ZpA5w=
Received: from [192.168.109.86] (unknown [123.149.251.210])
	by gzsmtp4 (Coremail) with SMTP id qCkvCgDH9p83HvZmXWKPAQ--.51340S2;
	Fri, 27 Sep 2024 10:53:47 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------yPj2x5Wxl5NSyNcKBiwTj5Xx"
Message-ID: <c3d3c52e-ec5b-4238-aac7-284a3838be90@126.com>
Date: Fri, 27 Sep 2024 10:53:42 +0800
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
From: Zhao Mengmeng <zhaomzhao@126.com>
In-Reply-To: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
X-CM-TRANSID:qCkvCgDH9p83HvZmXWKPAQ--.51340S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUzrWrUUUUU
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbimhNnd2b2GWtUhwAAso

This is a multi-part message in MIME format.
--------------yPj2x5Wxl5NSyNcKBiwTj5Xx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1ec6d097897a
--------------yPj2x5Wxl5NSyNcKBiwTj5Xx
Content-Type: text/x-patch; charset=UTF-8; name="test.patch"
Content-Disposition: attachment; filename="test.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL2JjYWNoZWZzL2VjLmMgYi9mcy9iY2FjaGVmcy9lYy5jCmluZGV4
IDE0MWE0YzYzMTQyZi4uYzcxN2Q4MGZkZmQ2IDEwMDY0NAotLS0gYS9mcy9iY2FjaGVmcy9l
Yy5jCisrKyBiL2ZzL2JjYWNoZWZzL2VjLmMKQEAgLTE0NCw3ICsxNDQsOCBAQCB2b2lkIGJj
aDJfc3RyaXBlX3RvX3RleHQoc3RydWN0IHByaW50YnVmICpvdXQsIHN0cnVjdCBiY2hfZnMg
KmMsCiAJCSAgIG5yX2RhdGEsCiAJCSAgIHMubnJfcmVkdW5kYW50KTsKIAliY2gyX3BydF9j
c3VtX3R5cGUob3V0LCBzLmNzdW1fdHlwZSk7Ci0JcHJ0X3ByaW50ZihvdXQsICIgZ3JhbiAl
dSIsIDFVIDw8IHMuY3N1bV9ncmFudWxhcml0eV9iaXRzKTsKKwlwcnRfcHJpbnRmKG91dCwg
IiBncmFuIGJpdCAldSwgbWF4IGdyYW4gYml0ICV1IiwKKwkJICAgcy5jc3VtX2dyYW51bGFy
aXR5X2JpdHMsIFU4X01BWCk7CiAKIAlmb3IgKHVuc2lnbmVkIGkgPSAwOyBpIDwgcy5ucl9i
bG9ja3M7IGkrKykgewogCQljb25zdCBzdHJ1Y3QgYmNoX2V4dGVudF9wdHIgKnB0ciA9IHNw
LT5wdHJzICsgaTsK

--------------yPj2x5Wxl5NSyNcKBiwTj5Xx--

