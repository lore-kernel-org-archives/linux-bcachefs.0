Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.9])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6D86B658;
	Fri, 27 Sep 2024 03:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727409311; cv=none; b=LJT1ybcDhd258yroJRN7MXI9wU0N3bloqY3v99nm2rnCJT2JyPb+a3vSR8DWSo0+PJUHP9q5PIFbvqdnYrAHOYMnJyNzLekhDYC7p0xI0jujVBVLNxMhz8bJN3ojHQMvD34sI+yPE4WVzBDAE6AxUw3zdDFvm+pOEqCWSIUDs/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727409311; c=relaxed/simple;
	bh=iqaJF5NRQ9p/9V+ZOaN3eSD72BJBivDH87HFf8iwVqc=;
	h=Content-Type:Message-ID:Date:MIME-Version:From:Subject:To:Cc:
	 References:In-Reply-To; b=qBd6ZcEWz1gRdTIwvRmcnpDsZ+Ls6yJnUmIABCFNyI9yKks3fp6aDOs4ZqMc1YKIdbuliInm0u8jQBe2EJlAluxgFeK44JHMWwYqbuWwOJuAtXkbuALkyLo/60euoyMPrdjSY9kw3+KPBl1mU/9i300eotUgGguiSxwldAUuweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=PklAlhP4; arc=none smtp.client-ip=117.135.210.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="PklAlhP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Content-Type:Message-ID:Date:MIME-Version:From:
	Subject; bh=iqaJF5NRQ9p/9V+ZOaN3eSD72BJBivDH87HFf8iwVqc=; b=PklA
	lhP4sbNx0reN1dmvNNXIWCSPxT+3YOEnZ/qlUj8hyX3JFb9XR16bI90uq8vxgLpx
	G3+ZSHIzwrLPOJq4cGi2McbvRO6VfI+NYzZ9a2V0kYOHmGFH6r6IsVxcCUH+PUms
	Yg11jFOH0A+gdYzEx6OXJryp+CBJyxN25Z07Tnc=
Received: from [192.168.109.86] (unknown [123.149.251.210])
	by gzga-smtp-mta-g2-5 (Coremail) with SMTP id _____wD3v1z0KPZm6awbAw--.36809S2;
	Fri, 27 Sep 2024 11:39:32 +0800 (CST)
Content-Type: multipart/mixed; boundary="------------etsjNww8NObPvIly7VJ0KH7p"
Message-ID: <ff3f13ee-2356-4731-8534-5813800f3757@126.com>
Date: Fri, 27 Sep 2024 11:39:31 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Zhao Mengmeng <zhaomzhao@126.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_stripe_to_text
To: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
In-Reply-To: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
X-CM-TRANSID:_____wD3v1z0KPZm6awbAw--.36809S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUzrWrUUUUU
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbi6Bdnd2b2KIgF6QABsy

This is a multi-part message in MIME format.
--------------etsjNww8NObPvIly7VJ0KH7p
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1ec6d097897a
--------------etsjNww8NObPvIly7VJ0KH7p
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

--------------etsjNww8NObPvIly7VJ0KH7p--

