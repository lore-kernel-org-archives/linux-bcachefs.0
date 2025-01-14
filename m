Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EE11537CE;
	Tue, 14 Jan 2025 16:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736873138; cv=none; b=CH7GOgnLS3fsfCgWmQ16l1ausCYyDxPS+3ENrHc2wNoZrM+JdN6oO3svh+kHuanBGlidRCUGk9EwiXI6xbeBtJdbwwguhKDgaNQDDj9lAgQBIG/nhuB3/04QaDp6s2GTnfYNuTlremraDRM7fxjkVOaP8Czz9eMrGdwA3EG2Fa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736873138; c=relaxed/simple;
	bh=U/NVFjeCF/8ae/CJzI2LOpp/MP0Q4iRbqJwfUhky48Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YuwLQgmq5c/7HuoUeq+oxTEik250fa7TJgDURaXpmZJwaTZzqrAti8cVNXrxiH3+WBPxREj7Hi2zZeP0G/Bpmzdq4hrVkGU92nL1CNE9Ato08k6yUWS41lpXPHOPWq6xAFHs+m/g52UgPYmDawzZqh+gNC2O0wHivGgCoKvQ9j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geekplace.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3cf094768so9929880a12.0;
        Tue, 14 Jan 2025 08:45:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736873132; x=1737477932;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U/NVFjeCF/8ae/CJzI2LOpp/MP0Q4iRbqJwfUhky48Y=;
        b=TO7rXkny4+hrFSi638VJ5FyRSctOEO5LPpun7PyIKpiwsvKly+I3XXyMn+D8g9jYl7
         goA3MYrmMhp7LBrzKKrF/KsoHZmjVF+Z3rnbMgixkZnc0sIYzXw/RR2B3bggYAFzaM4I
         fKBsJOs6Cw4oF1uO5bbVEhfW17yOQrtuAcBxP2atoQiTfp0Mqkb0467W6j+HO2WsJCx9
         tXcoKHbftYSb9KIjZSDtu/o1XoF7gsMTlo63GzVTZnQkb6D4689SUiIOC8UAlzhjAPsU
         c3jRy3fjJ9Cssm4gNdvqQKUYkeTyGOaaZY4+D2fa2bzjY8/3OdNQB8BaGmhxFhFAO12m
         8Gfw==
X-Forwarded-Encrypted: i=1; AJvYcCVHAlKBiKSq0tF7oAjlBgXVHBIPdiDar/ySgFGmZreZEUrteUq1YOBypulsKCCqr7Y3Nt36Ls1YVHxphDho@vger.kernel.org, AJvYcCVLmhzT3JIMDj8nhtixnjwO0bFswqSgLCQeyeTZp0nXWhv6V9+AOM/+Q53wselIjLRM5f62sXwo7Jal5fARYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwTwy3qdtNj5gDbpt6U82grU50n23ArN5x+fSVyeA6GLbH2m/uM
	peQt7ZLVr2F9TYkKhtNEE8XTR6hjLsjM/7cVpGHvJEOn/B32aiUh
X-Gm-Gg: ASbGncucBN4vDWr1NI5Q2c/K28HYb9eADLZlZMPkwiiM4Y6J5BmlMlzu746qBiWDoVO
	Lqgx1Cc/ckk7j7CDw1ahcd114ywaoVKI3eO/BTkcKgEMQV7dTY6Kaqh+0kkQneJrNHu+BqK5sVW
	XC+u5+7Lll2RzbDtHuHWNLAcyzVAlq2DkyNw1O4zRWq3YdDSW63CHxcSrolamOsG9Im0BBgKJyT
	KjUGNcEz1FBGaF2ubCWuuFJOviAn5Jjt/R8LOWWGrK37X3GxF8VqzXWI/aErgtjH9i1VT1Ylc+7
	jj/LWZRHEUPIHucxUb+hAJXCO5M=
X-Google-Smtp-Source: AGHT+IEM8Wq8g/L9ummHJAIyA5vjA1Gfm44UvRsAOoQxal2M/s5rFXVJ8LRW/cTdqSm3C0wetlk3nQ==
X-Received: by 2002:a05:6402:280e:b0:5cf:43c1:6ba7 with SMTP id 4fb4d7f45d1cf-5d972e6e58cmr19164105a12.30.1736873131704;
        Tue, 14 Jan 2025 08:45:31 -0800 (PST)
Received: from ?IPV6:2001:4091:a244:80ab:34fb:50ff:feac:591b? ([2001:4091:a244:80ab:34fb:50ff:feac:591b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c40e8sm6362283a12.25.2025.01.14.08.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:45:30 -0800 (PST)
Message-ID: <efd77e7d-aeb0-427b-8829-dd17b1795094@geekplace.eu>
Date: Tue, 14 Jan 2025 17:45:28 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <20250114143214.GT5388@noisy.programming.kicks-ass.net>
 <yry5ukfmnfcfemtebcfxgg3mbueil7rgakqzfzdsx6iqn4ush7@3iuxjdj5sdoe>
Content-Language: en-US
From: Florian Schmaus <flo@geekplace.eu>
In-Reply-To: <yry5ukfmnfcfemtebcfxgg3mbueil7rgakqzfzdsx6iqn4ush7@3iuxjdj5sdoe>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QwTtblEl1BBa9zelAgqudUMi"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QwTtblEl1BBa9zelAgqudUMi
Content-Type: multipart/mixed; boundary="------------OWFWysO2rcdb3zw94614LveR";
 protected-headers="v1"
From: Florian Schmaus <flo@geekplace.eu>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <efd77e7d-aeb0-427b-8829-dd17b1795094@geekplace.eu>
Subject: Re: [PATCH 2/2] bcachefs: set rebalance thread to SCHED_BATCH and
 nice 19
References: <20250114130513.498482-2-flo@geekplace.eu>
 <20250114130513.498482-4-flo@geekplace.eu>
 <20250114143214.GT5388@noisy.programming.kicks-ass.net>
 <yry5ukfmnfcfemtebcfxgg3mbueil7rgakqzfzdsx6iqn4ush7@3iuxjdj5sdoe>
In-Reply-To: <yry5ukfmnfcfemtebcfxgg3mbueil7rgakqzfzdsx6iqn4ush7@3iuxjdj5sdoe>

--------------OWFWysO2rcdb3zw94614LveR
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTQvMDEvMjAyNSAxNi4yNSwgS2VudCBPdmVyc3RyZWV0IHdyb3RlOg0KPiBPbiBUdWUs
IEphbiAxNCwgMjAyNSBhdCAwMzozMjoxNFBNICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90
ZToNCj4+IE9uIFR1ZSwgSmFuIDE0LCAyMDI1IGF0IDAxOjQ3OjI4UE0gKzAxMDAsIEZsb3Jp
YW4gU2NobWF1cyB3cm90ZToNCj4+PiBXaGlsZSB0aGUgcmViYWxhbmNlIHRocmVhZCBpcyBp
c3VhbGx5IG5vdCBjb21wdXRlIGJvdW5kLCBpdCBkb2VzIGNhdXNlDQo+Pj4gYSBjb25zaWRl
cmFibGUgYW1vdW50IG9mIEkvTy4gU2luY2UgInJlZHVjaW5nIiB0aGUgbmljZSBsZXZlbCBm
cm9tIDANCj4+PiB0byAxOSwgYWxzbyBpbXBsaWNpdGx5IHJlZHVjZXMgdGhlIHRocmVhZHMg
YmVzdC1lZmZvcnQgSS9PIHNjaGVkdWxpbmcNCj4+PiBjbGFzcyBsZXZlbCBmcm9tIDQgdG8g
NywgdGhlIHJlYmxhbmNlIHRocmVhZCdzIEkvTyB3aWxsIGJlIGRlcHJpb3RpemVkDQo+Pj4g
b3ZlciBub3JtYWwgSS9PLg0KPj4+DQo+Pj4gRnVydGhlcm1vcmUsIHdlIHNldCB0aGUgcmVi
YWxhbmNlIHRocmVhZCdzIHNjaGVkdWxpbmcgY2xhc3MgdG8gQkFUQ0gsDQo+Pj4gd2hpY2gg
bWVhbnMgdGhhdCBpdCB3aWxsIHBvdGVudGlhbGx5IHJlY2VpdmUgYSBoaWdoZXIgc2NoZWR1
bGluZw0KPj4+IGxhdGVuY3kuIE1ha2luZyByb29tIGZvciB0aHJlYWRzIHRoYXQgbmVlZCBh
IGxvdw0KPj4+IHNjaGVkdWxpbmdsYXRlbmN5IChlLmcuLCBpbnRlcmFjdGl2ZSBvbmNlcyku
DQo+Pg0KPj4gc29ydGEuLiB3aGF0IHdvcnJpZXMgbWUgbW9zdCBhYm91dCB0aGVzZSBwYXRj
aGVzIGFyZSB0aGUgY2xhaW1zIHdpdGhvdXQNCj4+IGJhY2tpbmcgbnVtYmVycy4NCj4+DQo+
PiBTdXBwb3NlZGx5IHRoZXJlIGlzIGEgcHJvYmxlbSwgYW5kIHRoaXMgaGVyZSBmaXhlcyBp
dCwgYnV0IGl0IGRvZXNuJ3QNCj4+IHJlYWxseSBnZXQgcXVhbnRpZmllZCBtdWNoIGhlcmUu
DQoNCkkgYW0gc29ycnksIFBldGVyOyBJIGtub3cgdGhhdCBjaGFuZ2VzIHNob3VsZCBiZSBt
b3RpdmF0ZWQgYnkgc29tZSBkYXRhLCANCmJ1dCBJIHVuZm9ydHVuYXRlbHkgZG9uJ3QgaGF2
ZSBhbnkgaW4gdGhpcyBjYXNlLg0KDQpBcyB5b3Ugd3JvdGUsIHRoZSBkaWZmZXJlbmNlIGJl
dHdlZW4gQkFUQ0ggYW5kIE5PUk1BTCB0YXNrcyBpcyB0aGF0IHRoZSANCmZvcm1lciB3aWxs
IG5vdCBpbW1lZGlhdGVseSBraWNrIGEgcnVubmluZyB0YXNrIGZyb20gdGhlIENQVS4NCg0K
V2l0aCB0aGF0IGluIG1pbmQsIGl0IG1hZGUgc2Vuc2UgdGhhdCBqYW5pdG9yaWFsIHRhc2tz
IHJ1bm5pbmcgaW4gdGhlIA0KYmFja2dyb3VuZCBhbmQgbm90IHJlcXVpcmluZyBhIGxvdyBz
Y2hlZHVsaW5nIGxhdGVuY3kgc2hvdWxkIHJ1biB1bmRlciANCkJBVENIIChhbmQgbm90IE5P
Uk1BTCkuIEJjYWNoZWZzJyByZWJhbGFuY2UgdGhyZWFkIGlzIGEgcHJpbWUgZXhhbXBsZSBv
ZiANCnN1Y2ggYSB0YXNrLg0KDQpBZGRpdGlvbmFsbHksIEkgYmVsaWV2ZSwgYnV0IHBsZWFz
ZSBjb3JyZWN0IG1lIGlmIEkgYW0gd3JvbmcsIHRoYXQgdGFza3MgDQp1c2luZyBCQVRDSCBp
bnN0ZWFkIG9mIE5PUk1BTCBncmFudCB0aGUgc2NoZWR1bGVyIG1vcmUgZmxleGliaWxpdHkg
dG8gDQpwcm92aWRlIHNjaGVkdWxpbmctbGF0ZW5jeS1zZW5zaXRpdmUgdGFza3Mgd2l0aCBs
b3dlciBsYXRlbmN5LiBCdXQgeW91IA0KYXJlIHJpZ2h0LCBJIHNob3VsZCBoYXZlIG1hZGUg
c29tZSBleHBlcmltZW50cyBpZiB0aGlzIGlzIHJlYWxseSB0aGUgY2FzZS4NCg0KDQo+IHll
YWgsIGl0IHdhcyBleHBsYWluZWQgdG8gbWUgYW5kIG1hZGUgc2Vuc2UgYXQgdGhlIHRpbWUs
IGJ1dCB0aGluZ3MNCj4gc29tZWhvdyBrZWVwIGZhbGxpbmcgb3V0IG9mIG15IG92ZXJmbG93
aW5nIGJyYWluLg0KPiANCj4gRmxvcmlhbiwgY291bGQgeW91IHVwZGF0ZSB0aGUgcGF0Y2gg
bWVzc2FnZSB3aXRoIHRoYXQ/IFdhcyBpdCBpbnRlbmRlZA0KPiBhcyBhIHBhcnRpYWwgd29y
a2Fyb3VuZCBmb3IgdGhlIHJlYmFsYW5jZSBzcGlubmluZyBpc3N1ZSBzb21lIHVzZXJzIGhh
dmUNCj4gYmVlbiBoaXR0aW5nPw0KDQpJIGRpZCBub3QgcnVuIGludG8gdGhhdCBpc3N1ZSBt
eXNlbGYsIGJ1dCBpdCBwcm9iYWJseSB3b3VsZCBoZWxwIA0Kc29tZXdoYXQgbWl0aWdhdGUg
dGhlIGVmZmVjdHMgb2YgdGhlIHBlcmlvZHMgZHVyaW5nIHdoaWNoIHRoZSByZWJhbGFuY2Ug
DQp0YXNrIGlzIENQVSBib3VuZC4NCg0KLSBGbG9yaWFuDQoNCg==

--------------OWFWysO2rcdb3zw94614LveR--

--------------QwTtblEl1BBa9zelAgqudUMi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGTBAEBCgB9FiEEl3UFnzoh3OFr5PuuIjmn6PWFIFIFAmeGlKhfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldDk3
NzUwNTlGM0EyMURDRTE2QkU0RkJBRTIyMzlBN0U4RjU4NTIwNTIACgkQIjmn6PWF
IFInPgf9HWtQOt3MJp1YIzVIz+eaXoZWwS4oZUOYrpwA/qHYy/z2j3WLr9/k+oqN
o0T4ufb+EG8EFNh24wWjAyQP9mNy7gpo40FgIw2byOPpboMo0Wbtjstov3BfMKoF
0dSkpMfy8tSUijehiLAeaGapLVjv34LPKffT891QIyDklLBBPMBp0bUWXSgyru8Y
QOaVhf5h68j6nN5AZEgld0v82/LkTxUcEvGwlCxaw7EVnnVqj1Xv1l91Mf/uDhHU
WuUcFDGx8D7Z4DoNJwGglM5gbpvqIqQ0SCgJc/0PGJhbTKwQI+TFQzBHbOW+If5Q
tOyQF+DujKS0TG0lrzUFvZPZtaEFVg==
=J2fI
-----END PGP SIGNATURE-----

--------------QwTtblEl1BBa9zelAgqudUMi--
