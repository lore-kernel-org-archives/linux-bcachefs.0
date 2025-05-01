Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7708821B9F2;
	Thu,  1 May 2025 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123533; cv=none; b=Ui8KFm9CxGLlMdMCe6LOi45TJ3NDUVy9dkN/hmZasunXrBVML96gbkIDgnA3OWzS7Er4aqZ1i0+Ucp+iAtyzEHIc1HH9F5whH6nd1BBUu4/90QGqYlMypSGaav7KqEEdU1sdysOodLLVuINDxI4yzgBlCUd/JAWmD3ncvY6HGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123533; c=relaxed/simple;
	bh=8AJ5TYwtCJyFK7YoXPMcpOfVbXhPX9Uum8GFRy8zp9Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=PVNZSVXCb7HVxeHB+V94laqioAIvwri5Aa8DWIood0nTmJjynfquhuATpvAkc7x8+f+5J0AVrqfJHIfjiSreQtPV3pIujaKYa7i1SlyVJeMhlfDPu+rt5Orz5nd6mGNok64oGv0gKGPiAWxWVA/NWKBYawDKF4zk/SqUvOyw+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bHiZnqQa; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bHiZnqQa"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-225477548e1so14711625ad.0;
        Thu, 01 May 2025 11:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746123530; x=1746728330; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31M2a7MzQFnr+QMjJl1jAmf5oWz7cYiRof9uFBocW/c=;
        b=bHiZnqQaMBIHcKek7LuB36Zyn3NeyyAkP8HdI1ox83zpTiQbtqlS0quQHGrwjOIbNk
         3kCoWaHvSLmkoULw3EFMiNk1p4Wrr92qUQMlg0cjVyJcQLALjM0Q14emEaHXa4SgCHlW
         CfHOpGX4qUYiHGdW6TSUaEsekAMMRBcNi4GCAiD+arWDcxrCKLtErY9ekH7x/nxXDe8s
         zqNYMAzORzsuYzsXC3MGPnWrg+G+DKKSHNO/vdsMNfFQsedTg+9ITzony6sspYt6ZJXP
         h9KiHTUI77HYvD/eo21opjvGWp1hP21vD60Sm603KYy+yZa/HFwpePS3OPVMc4DxHaRj
         pImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746123530; x=1746728330;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31M2a7MzQFnr+QMjJl1jAmf5oWz7cYiRof9uFBocW/c=;
        b=j16rXFKumE63QHNUx17KeTp6fG6iuERAzSP+Mls0rn5gLQRCWSrJ16vGdWrWH36VxW
         pHrZIJSrwT3RQiVO+k0neF3OWVZiw1qz7lDQWuEh7xI+SWQuNAHIIj4STZa2mAfEgN4a
         IaRyo9UhmhJfHuzgu9hb/PA0nQLng846cG93ILRM9w1PN43OPXSQnsdU58VGGdquYivH
         JGXhIG/knjsgHiLLzQ+6+wjiYSlFOXWdm6hX4wZ2Ta+RMvN4hv/9O+FZ2dgQoDsmgRaE
         t8EaT5caHJHzJK66zHTo2qOpuPxhw09/aD3wtuX4AykvMXZU3e44JV612We9Z0PKbd72
         6p/g==
X-Forwarded-Encrypted: i=1; AJvYcCUyAjPOk/jEP2VtIZgEY2pEeY9EaYMSz2kZJbuL2eU4u41KQcvTbUP1OQMW4yc6iN7C6EIO4V5fbCV4c3rlUA==@vger.kernel.org, AJvYcCXPhoXUu4cjteTrp7ltqmcfmCCB+QV4woDGrhlIp5j9d3uM0TNDumNk85x8tCgolFiVvpCFlDj0hpHhGV7v@vger.kernel.org, AJvYcCXtlK/6M/P+/FkPuCAFkBohh/SV+J9QDD2Gvyde8cxKSMoJpUgJqC3F6WbppQhx9OP9U7KLiraVThYdaypzpwVt@vger.kernel.org
X-Gm-Message-State: AOJu0YzIymXWuh9iGvosMd8UUrptJ15Xsmu4q+RkqZNmijx1gXTO76WF
	ZFAjrVpa+YXOEhU2p3v6z23SYm+ZErVw6RLXj6iAAZn3zDN2YrVsbMVo8A==
X-Gm-Gg: ASbGncuLzIAXdpuyK3xx0WDMYf1nG7Sz41qz0CkKio8uVE0Eu52Xt4DtqzBnSDcB4jP
	WKaPE4dxxB9J/O4VAsz/a874wRexpxIxr4TeAcErzwwXnpVReY+kaWJIntnYQhCZzHI1esRjuQa
	vPPsRvFkrx+D7Edt5pZAs+x4+BnCYMgnCgcon9hVG5opebL66OIbYGHvZtSoorJ53E2ovd0jYPI
	8XIiHU9GJoPyWJGWQC6IuZK+2Z3MG4jimOE940deVazVZ0YynVbpmnmY2pmmAGENbmkE0Em9xLv
	RxOrnPF/0GSOwjXhWpfTYKLt
X-Google-Smtp-Source: AGHT+IHy6Ll3Z23nZVuIrTV6UN983Ah2h/ki0XZ6sOPNNuE027Lh/hRUnu81RjOmmeyjewU+wWuOdA==
X-Received: by 2002:a17:902:d482:b0:224:1ec0:8a16 with SMTP id d9443c01a7336-22e1033c89cmr654615ad.21.1746123530559;
        Thu, 01 May 2025 11:18:50 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bc7b0aasm9831765ad.169.2025.05.01.11.18.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 May 2025 11:18:49 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <aBO2XVSisMXtU8nD@archlinux>
Date: Fri, 2 May 2025 02:18:33 +0800
Cc: kent.overstreet@linux.dev,
 Thorsten Blum <thorsten.blum@toblux.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Bill Wendling <morbo@google.com>,
 Kees Cook <kees@kernel.org>,
 regressions@lists.linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 ardb@kernel.org,
 ojeda@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD12E746-2B59-4AF5-B396-4700C6D099F9@gmail.com>
References: <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux> <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux> <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux> <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
 <aBOtxplvvpgHed7o@archlinux> <D9967EB7-7F4D-4122-9470-DB14700FD906@gmail.com>
 <aBO2XVSisMXtU8nD@archlinux>
To: Jan Hendrik Farr <kernel@jfarr.cc>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

> On May 2, 2025, at 01:58, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>=20
> On 02 01:28:28, Alan Huang wrote:
>>=20
>> Thanks,
>> Alan
>>=20
>>=20
>>=20
>>> On May 2, 2025, at 01:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
>>>=20
>>>>=20
>>>> I wonder if the __counted_by(x_name_len) in struct bch_xattr is =
needed, since there is also a value after x_name.
>>>=20
>>> Wait a minute. Are you saying that the value with length x_val_len
>>> is behind the name (of length x_name_len) at the end of the struct.
>>> So essentially the flexible array member x_name has a length of
>>> x_name_len + x_val_len and contains both the name and value?
>>=20
>> Yes.
>=20
> I assume you can't easily change the struct such that there exists a =
member
> that contains the result of x_val_len + x_name_len, correct?
>=20
> In that case the only available course of action at this time is to
> remove the __counted_by, because it is incorrect.
>=20
> In addition I would recommend changing the name of x_name to something
> like x_name_and_val or similar. It's very misleading to call it x_name
> when it also contains the value.
>=20
>>=20
>>>=20
>>> If that's the case:
>>>=20
>>> 1. that's not at all clear from the struct definition
>>> 2. __counted_by(x_name_len) is not correct in that case
>>>=20
>>=20
>> Both clang and gcc say:
>>=20
>>    =E2=80=A2 p->array has at least p->count number of elements =
available all the time.=20
>>=20
>> Note the at least here. Though I think the counted_by is misleading =
here.
>>=20
>=20
> Here's how clang defines __bdos language extension [1]. Also note the
> attribute reference for __counted_by [2]. It assumes that the flexible =
array
> member contains exactly the amount of elements that are specified.
>=20
> I guess your quote from the gcc docs is misleading, as gcc's behavior
> is like clang's.
>=20
> The kernel uses the type & 2 =3D=3D 0 case.
>=20
> So let's say you have a simple struct like so:
>=20
> struct foo{
> int val_len;
> char val[] __counted_by(val_len);
> }
>=20
> If val_len is 10 then foo->val[10] will be considered out of bounds.
> Even if you did a malloc for enough space.

OK, thanks, I=E2=80=99ll revert that.

>=20
> [1] =
https://github.com/llvm/llvm-project/blob/3b88805ca20018ae202afd3aea39f4fa=
856a8c64/clang/docs/LanguageExtensions.rst?plain=3D1#L5502-L5507
> [2] =
https://clang.llvm.org/docs/AttributeReference.html#counted-by-counted-by-=
or-null-sized-by-sized-by-or-null
>=20
>=20
> Best Regards
> Jan


