Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EF8189528;
	Fri, 15 Nov 2024 08:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659237; cv=none; b=T/KHOsDFDB/BS30f8xSxtklRGzppuwV9+HBWRH4wAYI85iqBb8E8UXdMIqKak/uuAFA/kHGNoyy1lVn+SD0fY/ePPQSpmuvCDv/j8gWzxfQo1VTm5gq485g4riVQoKyP+Vx6AQ6TfHsBfPwljl8PiXtXHXcGAVff2pLlhn0rnRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659237; c=relaxed/simple;
	bh=o8nIyJkuzItCALeJbV66s26MolutOjCijCbhPspD4Ws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qa9OZ/0T7TYAJLfYlPNC1aBtZW1aUeo/6wEi1SxHNk2QuruaRKDRwyJh6tPMYM58A0RROLcOFfO8JwnDg9jM1PQB6QzyuFC0oBaudO3i+sKOA34o0GIDzZv3IpjAIWBi65aeP/g1l9zk/npX8kkwyVZbnxWo38L/7SgNwH5kkrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4315eeb2601so16506025e9.2;
        Fri, 15 Nov 2024 00:27:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731659223; x=1732264023;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o8nIyJkuzItCALeJbV66s26MolutOjCijCbhPspD4Ws=;
        b=tp6nifwiLXkRdsH0L4LULiJdCtNPgeJHr8znl9/ytBN23uy/ObDrU+WNuyC1RY4JyB
         0QMbHpkm/y+0Ja1oGDIdimfaiFdVDXpypiXQNGXmJz2T94RA+tSO4MhNZ3ROcHQ2Yaq4
         uIMy53LfagDY7qjKfHt3HIyz8FMNFKAIKkEjAOz5i/VT4kyd/vHi9Jl6ChuB6dfg5Dlp
         b1W4GolCbtiM0HZf/0a860huWYBxHExBXk4qFFn5ZwTNyPBAnYCBv7F8o4jM/WBGLAzF
         Dnkt/qJTWqRlKvUYjWpZAJZM6n5/r4xTipKp82x1PNPytHjeSuquyCXHOK0fEhYeF1S8
         /VIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK74wrz2KFdcVFq/DJ3JHGF++Id4dhES1nqtEtTvnb10qK6EZq/laDLZG287YM91DL2eCRjaUS1dfA09s=@vger.kernel.org
X-Gm-Message-State: AOJu0YypGrlxF3lqwC8aCQHnymELYU76Xhk7L/1W6bE5RN563/0iQRr5
	upyLgfWnPTrDTKQehGhg628fCiheS63SWExvWAqrOfUHxHjPvF4ynn1bw9k+
X-Google-Smtp-Source: AGHT+IH/f12vAPRislm673eISgjINdIGmF89I7seSRP7QcD2GJSIitawye+dyoCh8yJa/pqkymQRVQ==
X-Received: by 2002:a05:600c:19c6:b0:431:5533:8f0d with SMTP id 5b1f17b1804b1-432df793dd5mr17166385e9.30.1731659222644;
        Fri, 15 Nov 2024 00:27:02 -0800 (PST)
Received: from ?IPV6:2001:4090:a247:82fb:34fb:50ff:feac:591b? ([2001:4090:a247:82fb:34fb:50ff:feac:591b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dab80a28sm46404765e9.24.2024.11.15.00.27.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2024 00:27:01 -0800 (PST)
Message-ID: <7a4a39f0-2694-42a0-b26d-b1e337eb3afc@geekplace.eu>
Date: Fri, 15 Nov 2024 09:26:56 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: Set rebalance thread to SCHED_BATCH and
 nice 19
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241114210649.71377-1-flo@geekplace.eu>
 <20241114210649.71377-2-flo@geekplace.eu>
 <kycrjg4nlgwxb6b6wph3uolmh45t7ivmoi5jpy4pakvh74wnoo@wp7hlbcbtwyw>
Content-Language: en-US
From: Florian Schmaus <flo@geekplace.eu>
In-Reply-To: <kycrjg4nlgwxb6b6wph3uolmh45t7ivmoi5jpy4pakvh74wnoo@wp7hlbcbtwyw>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------NQh0VyCdSM9kOJIS0Omdz4Og"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------NQh0VyCdSM9kOJIS0Omdz4Og
Content-Type: multipart/mixed; boundary="------------SSth0S6U9OM1ccsA5Ervezib";
 protected-headers="v1"
From: Florian Schmaus <flo@geekplace.eu>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <7a4a39f0-2694-42a0-b26d-b1e337eb3afc@geekplace.eu>
Subject: Re: [PATCH 2/2] bcachefs: Set rebalance thread to SCHED_BATCH and
 nice 19
References: <20241114210649.71377-1-flo@geekplace.eu>
 <20241114210649.71377-2-flo@geekplace.eu>
 <kycrjg4nlgwxb6b6wph3uolmh45t7ivmoi5jpy4pakvh74wnoo@wp7hlbcbtwyw>
In-Reply-To: <kycrjg4nlgwxb6b6wph3uolmh45t7ivmoi5jpy4pakvh74wnoo@wp7hlbcbtwyw>

--------------SSth0S6U9OM1ccsA5Ervezib
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUvMTEvMjAyNCAwNi40MywgS2VudCBPdmVyc3RyZWV0IHdyb3RlOg0KPiBPbiBUaHUs
IE5vdiAxNCwgMjAyNCBhdCAxMDowNjo0OFBNICswMTAwLCBGbG9yaWFuIFNjaG1hdXMgd3Jv
dGU6DQo+PiBTZXQgdGhlIHJlYmFsYW5jZSB0aHJlYWQncyBzY2hlZHVsaW5nIGNsYXNzIHRv
IEJBVENILCB3aGljaCBtZWFucyBpdA0KPj4gY291bGQgZXhwZXJpZW5jZSBhIGhpZ2hlciBz
Y2hlZHVsaW5nIGxhdGVuY3kuIEhvd2V2ZXIsIGl0IHJlZHVjZXMNCj4+IHByZWVtcHRpb24g
ZXZlbnRzIG9mIHJ1bm5pbmcgdGhyZWFkcy4NCj4+DQo+PiBBbmQgd2hpbGUgdGhlIHJlYmFs
YW5jZSB0aHJlYWQgaXMgdWFsbHkgbm90IGNvbXB1dGUgYm91bmQsIGl0IGRvZXMNCj4+IGNh
dXNlIGEgY29uc2lkZXJhYmxlIGFtb3VudCBvZiBJL08uIEJ5IGluY3JlYXNpbmcgaXRzIG5p
Y2UgbGV2ZWwgZnJvbQ0KPj4gMCB0byAxOSB3ZSBhbHNvIGltcGxpY2l0bHkgcmVkdWNlIHRo
ZSB0aHJlYWQncyBiZXN0LWVmZm9ydCBJL08NCj4+IHNjaGVkdWxpbmcgY2xhc3MgbGV2ZWwg
ZnJvbSA0IHRvIDcuIFRoZXJlZm9yZSwgdGhlIHJlYmFsYW5jZSB0aHJlYWQncw0KPj4gSS9P
IG9wZXJhdGlvbnMgd2lsbCBiZSBkZXByaW9yaXRpemVkIG92ZXIgc3RhbmRhcmQgSS9PIG9w
ZXJhdGlvbnMuDQo+IA0KPiBJcyB0aGVyZSBhIHBhdGNoIDEvMj8NCg0KU29ycnksIHBhdGNo
IDEvMiB3YXMgdW5mb3J0dW5hdGVseSBub3Qgc2VuZCB0byBsaW51eC1iY2FjaGVmc0AuIFlv
dSBjYW4gDQpmaW5kIGl0IGF0DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAy
NDExMTQyMTA2NDkuNzEzNzctMS1mbG9AZ2Vla3BsYWNlLmV1Lw0KDQotIEZsb3JpYW4NCg0K
DQo=

--------------SSth0S6U9OM1ccsA5Ervezib--

--------------NQh0VyCdSM9kOJIS0Omdz4Og
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEl3UFnzoh3OFr5PuuIjmn6PWFIFIFAmc3BdFfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDk3
NzUwNTlGM0EyMURDRTE2QkU0RkJBRTIyMzlBN0U4RjU4NTIwNTIACgkQIjmn6PWF
IFLncwgAkg2maj40YKOztZ6JH6GIdjO/XS74BuwOxFSmv7hnVL7m5Usm/gWGa9Ui
EScGLrLvVid9kfrPVDMPDWrXY94bgIm+Xd1q73Z0MVeWBUnrSAgctaS1JssJ1sGf
ElrsOq/BPtwJcNe6qRnNhnVdqze0Xs8u4QP0AbsxKGQFy/k11oUcizpwFpO3jcmg
TCLtSrSZIqwPX5NQwLQ5SCv4fg3xnxUYpy30CkGTp4PGu3rBVRUt7XzT4fWXPXdM
TNkUpYkZoy7FmNJDtqpaVu5uvMIVCjtdAzNHT+g6wBT6ZjNtsz8ArxAXR1BJBYJa
zhiu8jzKIOB4cgSqhBZoXebACdAlSA==
=x1zA
-----END PGP SIGNATURE-----

--------------NQh0VyCdSM9kOJIS0Omdz4Og--
