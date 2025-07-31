Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F0827456;
	Thu, 31 Jul 2025 20:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753992043; cv=none; b=Di5e/6zq2ShvZEIKsz05s19pSCr76OR1Ge3bFqRyZUZEu2qFHOREpXbOrznf49XyYOGeoZgkRtqYwy3V/7am/BCIoN8MrfjSjdbeD9iril9HRUedmO2UMpPuEggJ4JhdA1LufpeFxVYnuOI4QL9gPS+2OY8Q5AFWb0UQmJ0+u8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753992043; c=relaxed/simple;
	bh=KSr9SKUuJnNy2tJrle49CG5mOAKk5gXefGXMogzjQ8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozxIfZ4tesYgxzxXyEdBx/fOHoRcvreNWyF7nLXQjEmm2uvMoXufBWT+m68vCn5V6LOVMAU6MkD1E9pYC9p10VvCCncZsvzw90DjdGHvpro20o/yGDyc+bdEVQ/Yh14ay71j+KIAS7zNCSqgvYPnBmD9SNo0RQlQKstZa7RuMMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=U52P48GJ; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="U52P48GJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1753992033; x=1754596833; i=markus.elfring@web.de;
	bh=KSr9SKUuJnNy2tJrle49CG5mOAKk5gXefGXMogzjQ8Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=U52P48GJuJLg80AeOYQE8lxi7ZEgSVtF7TuMgTXkGfM+wqpXKUaJN6h1uRn5lChk
	 E6gI7tzsuCY/RfO4arTdE+2qf+WMnmQ/EuUGcTwgkjpwERsIh0RtZYXkrnYbhGkAI
	 E86aclTWP1zywrxi/0AL8JxY+2Ru+Bqg5Cl5ULgwIr8VInruyAugfSB1XrkvBbUam
	 dA8L3e6jOZVgej59TEKNOm2E6BVBSUnjRwcOqdabD08kgwjeVNPRCgruibmGmQdxz
	 Opd/DnK4kZHYqSsry1WP9dQIpxKzTXb/WREtT7hzfPO2dEaiAywZlFADtuyWIzQR/
	 kfcFFdpQ03FMCNgmWw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.235]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MoNZM-1uJHJo36ym-00cQYY; Thu, 31
 Jul 2025 22:00:32 +0200
Message-ID: <a3860880-acfb-41cc-98dd-0d878d9b37dd@web.de>
Date: Thu, 31 Jul 2025 22:00:31 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcachefs: Simplify kzalloc usage
To: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>, LKML <linux-kernel@vger.kernel.org>
References: <20250731131551.218666-1-liaoyuanhong@vivo.com>
 <32fbb160-4888-4d57-bd16-62ece192e81c@web.de>
 <ztnjjzlx3a2cvmxnc3jx2umwlh2faetdy6rzhmuc746vppmuns@lzn33bv2smpz>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ztnjjzlx3a2cvmxnc3jx2umwlh2faetdy6rzhmuc746vppmuns@lzn33bv2smpz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:06NHZfvvTF0m5iIpsJBc35dxSd3GPBSNMfA2KCv3fcesj1mFZXg
 QERezliNECFrQ1h3Edt9InCgYk1Tp+OIJNz+GYvlS3FXiyPiBrQQH001YNsMJjXOMAyNwyG
 owGeYYp0SxP+kQ6+/hzye8272ABnGgTZh07ScS7UQWQfODza74n458Vpu1lht9e1nHQI1Xf
 WWxl/p87ohHjEK1/y/g6Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:QEvfH6OB8yQ=;kQyErcWToBL/LFEKsXBOaNgJhS1
 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
 Inc47IZd+bCHFBWoXbz7GLk=

>>> Use the shorter variants will improves further maintainability.=20
>>> Convenient for subsequent code updates or refactoring.
>>
>> Please improve such a change description.
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv6.16#n45
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/coding-style.rst?h=3Dv6.16#n941
>=20
> The commit message is reasonable, it communicates the intent.

* I would wonder about the relevance of a shorter item here.

* Would you like to avoid wording weaknesses?


Another example for previous contributions:
https://lore.kernel.org/all/?q=3D%22Improve%20size%20determinations%22


> I haven't decided if I want to apply it; the dereference approach is
> better in principle but it's very far off into the weeds of "things that
> will never, ever cause an actual problem".

Have you got development views which might be in contradiction
to the preferred Linux coding style?

Regards,
Markus
