Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D835833A03D
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608083; cv=none; b=Ri1PDOF+tWxlis6lGVkUJzpvVw/sLbf9wn7ufa3WbwsPxg3Hj7E7GyamPy6jBrGENAyuLtKgchPUrQvvPHbAG/mcf/ke/7h2k/wPvx3/c8x/F4lKw5t4byzh+xb+lngktPKvmbeEw+cqPQhX3o/m0n8BpTnSBkJRJCN9hlxy1zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608083; c=relaxed/simple;
	bh=PaNYqLES+8TcjAZ4DYYe8T3TYtq2QhmV/2MX5pgF3sI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sEHjipmMbGXWBaKJUTXQp1HUaEFToP8Rf5EXMfl2yUj/LWZRIPDV+sxaFAdw0BV9AmnJGQjxA2Rl1xbcw9dBqfaLnISnfMlVsPQhUqbgsQC8du4cZmdG2rhett7u1TjKLKln+MPBlnkxyJTx5Ud6Kdg1kiUcVVKVGZFXHFJF33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2qV43CF; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2qV43CF"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61cb4374d2fso1418012a12.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 11 Sep 2025 09:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757608080; x=1758212880; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PaNYqLES+8TcjAZ4DYYe8T3TYtq2QhmV/2MX5pgF3sI=;
        b=F2qV43CFvqaUgnTiP3XXUWcZwywPdztjEdCMSE3/Lo+MLontJjsQS86X6aYmAu0HU4
         ILkZr7u9MwQyshLYkUpr/SeikbRAMMO9MjEkR33jnE+rLXOLn0XeHt8N/zblincxivOd
         6JdoD9K/zaYY4NqcczjF+M0wjI7FnjrBdUH3DlYKO2+ucxLr3E5aQyzi2u+R2yRcBma6
         6h/fKK3kBl5+CdwYmqC2pUsx/pieVQx/BV5aO9BpwxZ+xr86ucf89WbgcewMjYbrntO9
         o9Ct6AYSCPZI3BTb75uQE755XvqNYWFvxK/epPfUfwJ1zWKuIy5nKKtZ9BNkyq8FVp2P
         JmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608080; x=1758212880;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PaNYqLES+8TcjAZ4DYYe8T3TYtq2QhmV/2MX5pgF3sI=;
        b=kSMBNYHB6cmLGRRmb11iyptK56OzlG1C7pfrJYIN7BIsddzBaH7UYKr/OkCgDtCiGp
         f873c20OwwsABcB9iB/U/jhAuNTeypPivx+hdD8h0vc2emA2EeceayeE8/uFyexMHEf4
         TpE6h3IdA3+ttndzZCutymuXuaOF5/yy5M9KY9vpUICc+0lgtVC4HlzWhdQ5pns+eScG
         993oQqTgTYL7h4bd/JieX2wsnL/jVD19PLURtMvWjmDzG1zsCe/pV9yO7qrvu2XYUwwz
         ceWEL1TBwVxEZY/v+lsSbNgSc78aPCcZYUKJLFGxKrCWoYbzwPaPx11+XbHAVy0ILBQS
         NTwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWStbXciLkbGqMccu2cfvyFY71V9q2/owsxYUAEzZPR40rkNpVjg72zV4hT5vd/KS1JFeuPLr/k2tPD0nnnJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwHILcPFk9omOiS4jVEjcloDTGkI/2QdufiA7WeqYNczNAb8Uj
	bKPAKQNlLcn2idVCHd0LJFbX2hsducEh+DvhaPWaWHPn0YyQXNB1wMl2uhZP2PcpK0HT9IFB47J
	Q69oRJDwPKoYjJoRHYV12T7kKXXOlJV4=
X-Gm-Gg: ASbGncsy7VuTNE5WbmfJ7IorB8ptYBewyeMiqQNb+3C7e/iLQOoIjuw0UnayOoH3gks
	vRwgTej7G7syFfhmNPHv4FA9oPaMyCdn+G2EtgbwM/WbrRAX1apIRsRI5q3d/uAGaTCrP5KIMP6
	YOJVjOfOF7pI+qx1YQd0hyEtCbl0R5AJT+MfZlZVZh3jrrvO9+N1qpb/p4UKWrkaoRPLOlmsM7K
	OzRTSN7DR4b5EX1wEY=
X-Google-Smtp-Source: AGHT+IHIUfRCg4HgZEAPl1pLnDgGxTCcYg4y1vERTYIV1l7klIgYuKNjKv8paoLeF+9XlvK+mIDd2jNI3ZpigJDmwCs=
X-Received: by 2002:a17:907:804:b0:b04:8701:731b with SMTP id
 a640c23a62f3a-b04b14528eemr1973276566b.20.1757608079460; Thu, 11 Sep 2025
 09:27:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFYUeKswEh54fM5bFEvOfFLfc_GunKwEgr2uND=j-pxixQ@mail.gmail.com>
In-Reply-To: <CANypQFYUeKswEh54fM5bFEvOfFLfc_GunKwEgr2uND=j-pxixQ@mail.gmail.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Fri, 12 Sep 2025 00:27:23 +0800
X-Gm-Features: AS18NWCzIBxXnQT60gDOjeymLzDxHWaoT1L-41kL_5u3YXETyoFpBvjaBNApUzc
Message-ID: <CANypQFYGt3c1eoeytCzw3RKLw+cbtDDPJy8UM=aj8HQMC8MWmA@mail.gmail.com>
Subject: Re: [Linux Kernel Bug] WARNING in remove_vm_area
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	security@kernel.org
Cc: linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Content-Type: multipart/mixed; boundary="0000000000003bd727063e890506"

--0000000000003bd727063e890506
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Apologies for the oversight in my previous email. I neglected to
include the formatted report.

Please find the formatted report (formatted by syz-symbolize) attached
to this email. This should be easier to read and analyze.

Sorry for any inconvenience.

Jiaming Zhang <r772577952@gmail.com> =E4=BA=8E2025=E5=B9=B49=E6=9C=8811=E6=
=97=A5=E5=91=A8=E5=9B=9B 21:59=E5=86=99=E9=81=93=EF=BC=9A
>
> Dear Linux kernel developers and maintainers:
>
> We are writing to report a kernel WARNING in remove_vm_area,
> discovered with our modified version of syzkaller.
>
> This issue was initially found in kernel v6.17-rc5 (commit
> 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c). Unfortunately, we do not
> have a stable C or Syz program to reproduce this warning. We are
> actively analyzing the root cause and working to create a reliable
> reproducer, which we will share as soon as it is available.
>
> Attached are the kernel console output and the .config file for your
> analysis. Please let us know if any further information would be
> helpful.
>
> Best regards,
> Jiaming Zhang

--0000000000003bd727063e890506
Content-Type: application/octet-stream; name="report.log"
Content-Disposition: attachment; filename="report.log"
Content-Transfer-Encoding: base64
Content-ID: <f_mffmfunj0>
X-Attachment-Id: f_mffmfunj0

VHJ5aW5nIHRvIHZmcmVlKCkgYmFkIGFkZHJlc3MgKGZmZmZlOGZmYWM2NzMzOWEpDQpXQVJOSU5H
OiBDUFU6IDAgUElEOiA0NjI4MCBhdCBtbS92bWFsbG9jLmM6MzI4MiByZW1vdmVfdm1fYXJlYSsw
eDJmMy8weDMwMCBtbS92bWFsbG9jLmM6MzI4MQ0KTW9kdWxlcyBsaW5rZWQgaW46DQpDUFU6IDAg
VUlEOiAwIFBJRDogNDYyODAgQ29tbTogc3l6LjUuMzgyMyBOb3QgdGFpbnRlZCA2LjE3LjAtcmM1
ICMxIFBSRUVNUFQoZnVsbCkgDQpIYXJkd2FyZSBuYW1lOiBRRU1VIFN0YW5kYXJkIFBDIChpNDQw
RlggKyBQSUlYLCAxOTk2KSwgQklPUyAxLjE1LjAtMSAwNC8wMS8yMDE0DQpSSVA6IDAwMTA6cmVt
b3ZlX3ZtX2FyZWErMHgyZjMvMHgzMDAgbW0vdm1hbGxvYy5jOjMyODENCkNvZGU6IDQ4IDgzIGM0
IDIwIDViIDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIDVkIGU5IDA0IDA4IDcwIDA5IGNjIGU4IGFl
IGY4IGFjIGZmIDkwIDQ4IGM3IGM3IGEwIDc4IDk2IDhiIDQ4IDg5IGRlIGU4IDNlIDFiIDcwIGZm
IDkwIDwwZj4gMGIgOTAgOTAgZWIgY2EgMGYgMWYgODAgMDAgMDAgMDAgMDAgOTAgOTAgOTAgOTAg
OTAgOTAgOTAgOTAgOTANClJTUDogMDAxODpmZmZmYzkwMDAzNjI3YWQ4IEVGTEFHUzogMDAwMTAy
NDYNClJBWDogNDBhZmJhMzZlNDJmNDgwMCBSQlg6IGZmZmZlOGZmYWM2NzMzOWEgUkNYOiAwMDAw
MDAwMDAwMDgwMDAwDQpSRFg6IGZmZmZjOTAwMWY4ODcwMDAgUlNJOiAwMDAwMDAwMDAwMDdmZmZm
IFJESTogMDAwMDAwMDAwMDA4MDAwMA0KUkJQOiBmZmZmZThmZmFjNjczMzlhIFIwODogZmZmZjg4
ODAyYjgyNDI1MyBSMDk6IDFmZmZmMTEwMDU3MDQ4NGENClIxMDogZGZmZmZjMDAwMDAwMDAwMCBS
MTE6IGZmZmZlZDEwMDU3MDQ4NGIgUjEyOiAxZmZmZmQxZmY1OGNlNjcwDQpSMTM6IDFmZmZmZDFm
ZjU4Y2U2NzIgUjE0OiBmZmZmZThmZmFjNjczMzlhIFIxNTogZmZmZmU4ZmZhYzY3MzMzMA0KRlM6
ICAwMDAwN2YyZWFmODAyNjQwKDAwMDApIEdTOmZmZmY4ODgwOThlMWYwMDAoMDAwMCkga25sR1M6
MDAwMDAwMDAwMDAwMDAwMA0KQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAw
MDA4MDA1MDAzMw0KQ1IyOiAwMDAwMDAxMTBjMzQ0OGZmIENSMzogMDAwMDAwMDA0YWRjODAwMCBD
UjQ6IDAwMDAwMDAwMDA3NTJlZjANClBLUlU6IDgwMDAwMDAwDQpDYWxsIFRyYWNlOg0KIDxUQVNL
Pg0KIHZmcmVlKzB4NjMvMHg0MDAgbW0vdm1hbGxvYy5jOjM0MTQNCiByY3VfcGVuZGluZ19leGl0
KzB4NmI4LzB4N2IwIGZzL2JjYWNoZWZzL3JjdV9wZW5kaW5nLmM6NjMwDQogYmNoMl9mc19idHJl
ZV9rZXlfY2FjaGVfZXhpdCsweDkwMC8weGEzMCBmcy9iY2FjaGVmcy9idHJlZV9rZXlfY2FjaGUu
Yzo4MDkNCiBfX2JjaDJfZnNfZnJlZSBmcy9iY2FjaGVmcy9zdXBlci5jOjYxNiBbaW5saW5lXQ0K
IGJjaDJfZnNfcmVsZWFzZSsweDJhMy8weDgzMCBmcy9iY2FjaGVmcy9zdXBlci5jOjY2Nw0KIGtv
YmplY3RfY2xlYW51cCBsaWIva29iamVjdC5jOjY4OSBbaW5saW5lXQ0KIGtvYmplY3RfcmVsZWFz
ZSBsaWIva29iamVjdC5jOjcyMCBbaW5saW5lXQ0KIGtyZWZfcHV0IGluY2x1ZGUvbGludXgva3Jl
Zi5oOjY1IFtpbmxpbmVdDQoga29iamVjdF9wdXQrMHgyMjgvMHg0ODAgbGliL2tvYmplY3QuYzo3
MzcNCiBkZWFjdGl2YXRlX2xvY2tlZF9zdXBlcisweGJjLzB4MTMwIGZzL3N1cGVyLmM6NDc0DQog
Y2xlYW51cF9tbnQrMHg0MjUvMHg0YzAgZnMvbmFtZXNwYWNlLmM6MTM3NQ0KIHRhc2tfd29ya19y
dW4rMHgxZDQvMHgyNjAga2VybmVsL3Rhc2tfd29yay5jOjIyNw0KIHJlc3VtZV91c2VyX21vZGVf
d29yayBpbmNsdWRlL2xpbnV4L3Jlc3VtZV91c2VyX21vZGUuaDo1MCBbaW5saW5lXQ0KIGV4aXRf
dG9fdXNlcl9tb2RlX2xvb3ArMHhlYy8weDExMCBrZXJuZWwvZW50cnkvY29tbW9uLmM6NDMNCiBl
eGl0X3RvX3VzZXJfbW9kZV9wcmVwYXJlIGluY2x1ZGUvbGludXgvaXJxLWVudHJ5LWNvbW1vbi5o
OjIyNSBbaW5saW5lXQ0KIHN5c2NhbGxfZXhpdF90b191c2VyX21vZGVfd29yayBpbmNsdWRlL2xp
bnV4L2VudHJ5LWNvbW1vbi5oOjE3NSBbaW5saW5lXQ0KIHN5c2NhbGxfZXhpdF90b191c2VyX21v
ZGUgaW5jbHVkZS9saW51eC9lbnRyeS1jb21tb24uaDoyMTAgW2lubGluZV0NCiBkb19zeXNjYWxs
XzY0KzB4MmIzLzB4M2IwIGFyY2gveDg2L2VudHJ5L3N5c2NhbGxfNjQuYzoxMDANCiBlbnRyeV9T
WVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg3Ny8weDdmDQpSSVA6IDAwMzM6MHg3ZjJlYWU5YmQ0
NGUNCkNvZGU6IDQ4IGM3IGMwIGZmIGZmIGZmIGZmIGViIGFhIGU4IDJlIDIzIDAwIDAwIDY2IDJl
IDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwIDBmIDFmIDQwIDAwIGYzIDBmIDFlIGZhIDQ5IDg5IGNh
IGI4IGE1IDAwIDAwIDAwIDBmIDA1IDw0OD4gM2QgMDEgZjAgZmYgZmYgNzMgMDEgYzMgNDggYzcg
YzEgYTggZmYgZmYgZmYgZjcgZDggNjQgODkgMDEgNDgNClJTUDogMDAyYjowMDAwN2YyZWFmODAx
ZGE4IEVGTEFHUzogMDAwMDAyNDYgT1JJR19SQVg6IDAwMDAwMDAwMDAwMDAwYTUNClJBWDogZmZm
ZmZmZmZmZmZmZmZlYyBSQlg6IDAwMDAwMDAwMDAwMGZlODggUkNYOiAwMDAwN2YyZWFlOWJkNDRl
DQpSRFg6IDAwMDAwMDAwMjAwMGZlYzAgUlNJOiAwMDAwMDAwMDIwMDBmZjAwIFJESTogMDAwMDdm
MmVhZjgwMWUwMA0KUkJQOiAwMDAwN2YyZWFmODAxZTQwIFIwODogMDAwMDdmMmVhZjgwMWU0MCBS
MDk6IDAwMDAwMDAwMDAwMDAwMDANClIxMDogMDAwMDAwMDAwMDAwMDAwMCBSMTE6IDAwMDAwMDAw
MDAwMDAyNDYgUjEyOiAwMDAwMDAwMDIwMDBmZWMwDQpSMTM6IDAwMDAwMDAwMjAwMGZmMDAgUjE0
OiAwMDAwN2YyZWFmODAxZTAwIFIxNTogMDAwMDAwMDAyMDAwZmY0MA0KIDwvVEFTSz4=
--0000000000003bd727063e890506--
