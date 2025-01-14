Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07CE155301;
	Tue, 14 Jan 2025 16:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736873138; cv=none; b=USe5VdCPPY0EoDLnKUsoQkFLBW8sGeH/TQpFBW6rrXXCULVcV6KmrnnvILIm2YdDFcbPHA+yil4Q5BsgrYDNm98RzN5FgmegTL9KzKmplQJSiRYCuTH3NOZEtQ3dWH7ICu8M1JAEq11fC9cUblcVjN1vWwLzKivu+UcFU/HdthI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736873138; c=relaxed/simple;
	bh=ytoZVFRO4GUCMbloccLP7PwzRgx4K5XmFUZDdMJRjoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnrHmJkTr11GrhF8+H5FtrXep1+xbvK8GohXFUVGHNSxC8XuvatWSLUKZYZZup5DMSatUa5q0uIG7Ms0mUvYdvEj3pexfrXHAPctWJ62cPyk7256PPu5yA1rAYzQpFS/ov4eC7CXrldlWpAXKVtmCwdPY7TU1GBNQtI6PAEuLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso10058650a12.0;
        Tue, 14 Jan 2025 08:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736873134; x=1737477934;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ytoZVFRO4GUCMbloccLP7PwzRgx4K5XmFUZDdMJRjoE=;
        b=pwU7fXIjpcVhRNiFLjkoj6b4SuD2ysmJgSvtlSy010NfbWSuKOLq1b4VdMTNDGdlsh
         4FGa2/cr8KguL0Lht9sO2V75SbvUN708qJFZ2E2/OEqm04EPMZ8aOp5lpl3/rHDwzvkM
         zpzAehMcKnWVktTYV7GDg3jn8dub2ZEinEMV+1KRWsfNzJ52geLn7xtkECEn5h0GNIzG
         sWTB9CtFAetEzQ1Ft823NMxeluqnc0T+Ab2cXt/2zZvo8Sj3bWTzdLK5f2HZMl+HwqG9
         lw3WI9Tl/wuNP4yyuQzY5Mi45d6nySlIzcsvtU8X+tQJc3Fo70wXm0ep8ZTUTShz9F/l
         jGqg==
X-Forwarded-Encrypted: i=1; AJvYcCWf5yfBSbFGBt10GYj0q/ZZkIQ0Vh2fMoTnytF6YKdBdRkD3tfO84/HdI45et46U5IAFj3yIMQpeDnV4F8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRBisOr7yGpzB0uyMGozAh11kiKpRp4bSZpo4PlUk28EOrJz9H
	TfBvpIZq0pgCa1JyEiBCMTw/ErVWQVHl3Z/SxHusbgg1RP4w6Xfw
X-Gm-Gg: ASbGncvWxgohVG17jjP0pzeDNxEHDfTbexl4Ota0k7HU+IYr/JLWu3RCsFLQvfKFFHG
	EwrtCAk1mUuru7MvdGsWbPZXdds0EjjIsXKKbmompg3XWCv4ZSrgO0oTBLLgfa0d4udue1Y5ipa
	+lcyHHvAM59amLFyMqDiv8+0oMaO5aYNoOIHpbM20Y1SOpe4E5+PcwhJkaRiiZMvdbrI5OnkCLC
	Kx+KJcYpbQ1zrUywmzIVrxN12+k+iVQkkc5YZ2MZELZr6a9vhrWVpOncPn02SnMx14BH2r5MPfG
	1UuxDzFWiJ8h7StC58HtuOavxKE=
X-Google-Smtp-Source: AGHT+IENNXdhbcX3Vq8hST0+qqqKnWfZGBwrVZ36LorkyWO59v353IeJjUczvKVRLaPjkmrbd8l1AA==
X-Received: by 2002:a05:6402:350b:b0:5d2:7181:4a41 with SMTP id 4fb4d7f45d1cf-5d972e72512mr23902424a12.31.1736873133865;
        Tue, 14 Jan 2025 08:45:33 -0800 (PST)
Received: from ?IPV6:2001:4091:a244:80ab:34fb:50ff:feac:591b? ([2001:4091:a244:80ab:34fb:50ff:feac:591b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c40e8sm6362283a12.25.2025.01.14.08.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:45:32 -0800 (PST)
Message-ID: <31baf43d-8d10-41f7-87ad-87e6d2150592@geekplace.eu>
Date: Tue, 14 Jan 2025 17:45:29 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Ben Segall
 <bsegall@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
Content-Language: en-US
From: Florian Schmaus <flo@geekplace.eu>
In-Reply-To: <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Lj00gQIsm3W2aqPmnp7weXr5"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Lj00gQIsm3W2aqPmnp7weXr5
Content-Type: multipart/mixed; boundary="------------9983BtMz53JeNjpA6EeswNv0";
 protected-headers="v1"
From: Florian Schmaus <flo@geekplace.eu>
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Ben Segall
 <bsegall@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>
Message-ID: <31baf43d-8d10-41f7-87ad-87e6d2150592@geekplace.eu>
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>
In-Reply-To: <28688fa8-718b-4ee6-8417-822efac8b603@arm.com>

--------------9983BtMz53JeNjpA6EeswNv0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQvMDEvMjAyNSAxNC4yOSwgQ2hyaXN0aWFuIExvZWhsZSB3cm90ZToNCj4gT24gMS8x
NC8yNSAxMjo0NywgRmxvcmlhbiBTY2htYXVzIHdyb3RlOg0KPj4gV2hpbGUgdGhlIHJlYmFs
YW5jZSB0aHJlYWQgaXMgaXN1YWxseSBub3QgY29tcHV0ZSBib3VuZCwgaXQgZG9lcyBjYXVz
ZQ0KPiANCj4gcy9pc3VhbGx5L3VzdWFsbHkNCj4gDQo+PiBhIGNvbnNpZGVyYWJsZSBhbW91
bnQgb2YgSS9PLiBTaW5jZSAicmVkdWNpbmciIHRoZSBuaWNlIGxldmVsIGZyb20gMA0KPj4g
dG8gMTksIGFsc28gaW1wbGljaXRseSByZWR1Y2VzIHRoZSB0aHJlYWRzIGJlc3QtZWZmb3J0
IEkvTyBzY2hlZHVsaW5nDQo+PiBjbGFzcyBsZXZlbCBmcm9tIDQgdG8gNywgdGhlIHJlYmxh
bmNlIHRocmVhZCdzIEkvTyB3aWxsIGJlIGRlcHJpb3RpemVkDQo+IA0KPiBzL2RlcHJpb3Rp
emVkL2RlcHJpb3JpdGl6ZWQvDQo+IA0KPj4gb3ZlciBub3JtYWwgSS9PLg0KPj4NCj4+IEZ1
cnRoZXJtb3JlLCB3ZSBzZXQgdGhlIHJlYmFsYW5jZSB0aHJlYWQncyBzY2hlZHVsaW5nIGNs
YXNzIHRvIEJBVENILA0KPj4gd2hpY2ggbWVhbnMgdGhhdCBpdCB3aWxsIHBvdGVudGlhbGx5
IHJlY2VpdmUgYSBoaWdoZXIgc2NoZWR1bGluZw0KPj4gbGF0ZW5jeS4gTWFraW5nIHJvb20g
Zm9yIHRocmVhZHMgdGhhdCBuZWVkIGEgbG93DQo+PiBzY2hlZHVsaW5nbGF0ZW5jeSAoZS5n
LiwgaW50ZXJhY3RpdmUgb25jZXMpLg0KPiANCj4gcy9zY2hlZHVsaW5nbGF0ZW5jeS8NCj4g
SSBrbm93IG5vdGhpbmcgYWJvdXQgYmNhY2hlZnMgaW50ZXJuYWxzLCBidXQgY291bGQgdGhp
cyBhbHNvIGJlIGEgcHJvYmxlbT8NCj4gVGhlIHJlYmFsYW5jZSB0aHJlYWQgbWlnaHQgbm90
IHJ1biBmb3IgTyhzZWNvbmQpIG9yIHNvPw0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcsIG11
Y2ggYXBwcmVjaWF0ZWQuIEkgaGF2ZSBhZGp1c3RlZCB0aGUgY29tbWl0IA0KbWVzc2FnZSBp
biBteSBicmFuY2ggWzFdLg0KDQpCY2FjaGVmcyByZWJhbGFuY2UgdGFzayBpcyBub3QgcmVh
bGx5IHNjaGVkdWxpbmcgbGF0ZW5jeSBzZW5zaXRpdmUsIA0KdW5saWtlIGJjYWNoZWZzJyBj
b3B5Z2MgdGFzaywgc28gaXQgaXMgZmluZSB0byBydW4gaXQgdW5kZXIgQkFUQ0guDQoNCi0g
Rmxvcmlhbg0KDQoxOiANCmh0dHBzOi8vZ2l0aHViLmNvbS9GbG93ZGFsaWMvbGludXgvdHJl
ZS9iY2FjaGVmcy1yZWJhbGFuY2Utc2V0LXNjaGVkLWJhdGNoDQoNCg==

--------------9983BtMz53JeNjpA6EeswNv0--

--------------Lj00gQIsm3W2aqPmnp7weXr5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEl3UFnzoh3OFr5PuuIjmn6PWFIFIFAmeGlKlfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDk3
NzUwNTlGM0EyMURDRTE2QkU0RkJBRTIyMzlBN0U4RjU4NTIwNTIACgkQIjmn6PWF
IFI7YAf/e+Fc1/7q+dfx2uHEVWuwPknfkNdXN8dbLVw/V9dlcvQx5KsckQRwfaqY
ghLcso+jTuv3UxKgxHfkxFL/uSVhA07yULzb3afogu+N7NUuLopGaEcWjeY1jHdj
zzb83feACrXzZlLhPkMEOQ0nsE3cRIrCRuHAVIlPkVfx0Kqh3iOyAR0YSiLZPIgl
DBA1GVnrwk+xAEs//P3x5+uhSMEO5G/acat+zp27vc8KTIPlRinClPgVMTIBUVD/
fjAXRMTPVa1oROX66k0Mi2a3mijTlTtDhHihzdGd+klmNWRvsqumn9USq9n8VSz5
wnSlsb6v0Q8ZRWFsiXwVULbemw+9LA==
=q9Z6
-----END PGP SIGNATURE-----

--------------Lj00gQIsm3W2aqPmnp7weXr5--
