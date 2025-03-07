Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96A1192B8A;
	Fri,  7 Mar 2025 18:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741370475; cv=none; b=hh0qmaMAg+2c8hn/tIeDsOCf/DoTeN/3Q4MZMav44n1pIPc03gH0tjrEJGtHuIPdshWqUH9xldErXKC357dCOlZDwkR8JqJNhKr0o0XJicBdH8qr6IhVnsxRsJMBzHAfdtNEFGM7OHAwIdI7vQkM/isvbPglcVz2jv8fHqGWSpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741370475; c=relaxed/simple;
	bh=fc/YRA7+YxCdGwZiOQ9Sik/WdGzCbMxW/UHpNzNtcNc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=BXVydMOASRi5r9UYzT2JXriKCfrd23WOFou1Yc90GRKFUV3Qsk5XuOSiAH+B0gvtr1qiy0ApYJN0O5wRXcu8E1ZCOJWqkHsidEusjfrTWDVIcQHQHwhmDbmx8XgYFJXhEdzuH64NWLyL88tjw0FeoK28D9r3korouL78OkZc4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=S4cMIX1R; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="S4cMIX1R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1741370464; x=1741975264; i=markus.elfring@web.de;
	bh=fc/YRA7+YxCdGwZiOQ9Sik/WdGzCbMxW/UHpNzNtcNc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=S4cMIX1RIn0cX+t+LffCAsFlf49qppSk6wC5Cyk7A9a49Hnyt8lU663lBARpBIRZ
	 jvDgbRXUL/yD509LfZg7xWy/7GUPFXSqujx5gX2AV7nykkhwf1yF1hO8AFcoI7fVu
	 UCGGxBKeQQGiwkApaAGWsOqrYWx9wnKKUmnOegA+qLisy1SpMIwIiwsaoWSxNajyK
	 GFPdmS/g2ixk7VLD9YtEeQyAZkjQ2+y+mfuRDbEs4/bjYnTrkmonoxbA45iaP6Xd+
	 m/lZP2/izfw0LGw8j/LiIqmnlGRYSAwcfLN6LSvmL1K+loKkXHOheWQwpOF5Qq9HB
	 AN000z0U0FoD6CLPYQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.70]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MLzmv-1tYo8f1hJ3-00Mg13; Fri, 07
 Mar 2025 19:01:04 +0100
Message-ID: <1ed644b8-f3c4-4656-aad0-a3c4f7fb0533@web.de>
Date: Fri, 7 Mar 2025 19:01:03 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: vulab@iscas.ac.cn, linux-bcachefs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <20250304040311.2081-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH] bcachefs: Add error handling for bch2_folio()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250304040311.2081-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vFQpRg8a0qnuMOCHH60YdRw6epS7oSnGKjvElBWGifTarv7YKhm
 xFh91c7CC0nv5d8CYC1AY29fn0qYeBL/9Z+HOkF5N0w/wp/g3iOwBf6f8N7WOJn1g/mXtoM
 5s8TsmBRL1usIuSYsHUU0uuuzRj5VSvpIYAAhlYoZx0Zr3A6FJuNF/7zYO3x02hY0XldYOs
 ph62l3tIj7T3i8AOvPGfQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6CMoYsFod04=;+IBVpNIyfjLprH3EO/ur62pKUNo
 mxHzSFbhI8IPJgAsVgTt07VWRHWUenmQua3BcAadOoos99Cs3HqgLy+knnQpiy0a1aA3HZMXZ
 qfg2nEw7BWsY/qhOzNRhgSa6liKDOm3gh+f6nGsPyik4aZNidogcNyPO/9xj8RkjzoibgLVBr
 8gVulD5KHLPKIzJmWSCMZ3UZ4mYq7TzKRElOITbMPjqlk00XEuVoxQsLjx34COnn47rRV/H88
 LbUw8fiqKUev1i7mucwmZmOYxenTT3hncNCLb5M+k//UIC9/De1xs8vg5RlKnDOGF721EdAt2
 zbLlt6de7+KmHGDNMspRRu1/SxzDvWF7y3lwEmpBun08b4r4cpdSrPEqOrBAXm6ywYRkOimyD
 a/D99n0PxM/lbF9FFw4QO6XeNbFNyiyBv1hBgxuQohxtTkPgz3U0arb8IYSAPttDP1cCPUMYN
 t5sCaB6zXyHWTQLoeKaqQUqqOo3f3X7PwOz01ypNbdmj5sqTVfDIARLen4wnE0HBAHCn9cQmX
 0pOjuw23CO5D6jgCrWn/Y/osXGbWNS+4bQ9qPlFMJhx4V44uy3x4ADyplDXfAL+pvpC5VtmI5
 Nf3nVtiaCYPKg2QFhkKT45z3u6iEowPaU8+V9OzIW86rYwoV9WPpiWNIUdl0KACSrp6lCmTY7
 CZcPHD8hKa2hBxmEuDEJ5BLr/0ylRzkog8kx5v1xEDma8I3IHz9lZJDEoQY21WEgX3i4C1mHJ
 hZNUzLWoaQxhC3XPPyZBRKsne5eSdkZdleD2ZXbrDfvFIR+uQpXall2PwhS/zLfx4lH4MqAOw
 gKaTdqrm2FbogLctI1BL0A9LIfRTTgaz3PlYRV2wFABFTa/7UB4MNNB09ulHQDqcZvUduWkqC
 tx5665k8aTGkBSll6WuRaV1vTOLNpQvnaR22BEIAogVCkqkyxE+g1lcZpkn4xPJFEKwxNTd8w
 BH2EbLeZPnqrxHuMK0THet9gxFEjC1pxOqelpOlZ5Ptvr7J5p1+r31Y88zEZmRTqQHAOEr2+D
 U56cjWUo5MrvKENMeizxk+S/igiFPUSIcAEL7cImo1zVD+nBuAI4tkSiuD6KO6W6UvfB/UmFr
 GhwtkvqN9I2DURXZoDXqRsZmtFNMhcNN0bWxIPy7/0FC0B2KhUT3dljKAt4BVkWE+CQ/Maxbt
 O2CgxboOljkdo6Ja/D2f/knIOj+fHFBdxtJAj7O5Vs8xsXUy4hrFDE7prdQO5jqVGEdQTiPsI
 xum5Bwvn8LYId/olTbjPgkhfaas0ltq8i7T2IYG17YlnpXUkpbELE1Ezy/Y//OTlJW93TaL/t
 fMyyKa23k559yANuzBXvjV5OeYegbPvB4yTqVpdYaR+5xH3ZzxZB//zbP1qpf0sdaeRL089ES
 aksccNI1btctXCavzj6tVFEzfXYggbfDOp2uGXrtcmgUjyUhY32NkNbJ+ai3Cf55f11mBiOOG
 mbm4tSSa8z0R5LFDuw2UslRvSfvA=

> Add error handling for the case where bch2_folio() returns NULL
> in __bch2_folio_set(). Return immediately to prevent null pointer
> dereference.

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tre=
e/Documentation/process/submitting-patches.rst?h=3Dv6.14-rc5#n145

Regards,
Markus
