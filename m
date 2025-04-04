Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBBD1F0E31;
	Fri,  4 Apr 2025 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743784221; cv=none; b=tGRkC/0HfHzm26oKRTSy5Z+Lb2y1d6Rbfai57oWbkm+5xbQzRfLVYfVYdW2Vs3OdxI4Tt3LSDe2yUWJYpZTGATeU8Ch/0rydQp2i8swgtm2Cjtmn+d6v3CFKWqaL0y5fL7z7aQiXyKAHR5RMjbZT9q7rX3KoKgoUzQ3ALZY4L7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743784221; c=relaxed/simple;
	bh=WCrYYWI0xDyuwaFoWdGAyOq91c6ty/Guoy1qj2whQVI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FKWER4PRNRQrliQWBWfYN56gWiUkeOEuh42SjXTziWZPHtobaB6mMpz5EKrdN97zU1uUJQ++qw3ZbN/goJ7Og5+XcXR1yxfuct5yt3mF+NNmsrYWRoIFHNABum1KbjVXrPBmXRAaeiswKPQg9gui6NwuU3tRxvgLTxI3lF5glwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=ZPECPA+J; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="ZPECPA+J"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 851AA40407
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1743784212; bh=WCrYYWI0xDyuwaFoWdGAyOq91c6ty/Guoy1qj2whQVI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZPECPA+Jz5xIq0/kTgqLnp/yxU1lQlWMEyoq8bzMuKbFlN81wLn2Bct8zFi5h2hHV
	 SaYJpQtqmEvh+IqwJIkzxvqc5C4iWv8VYy/48C4gOMDrJX6dLCzgJVZNUzo2eL0ws8
	 4ls4BIvI/J89NFeofNokYVYGzfzZpRKj3tLyw3tvoNcesKFm6SYoOGfQ7aNQBxn3X7
	 mpJisIRt4xOK4+aVgRh6kMokANLfOvxyVMGO+HK+2VosX7p/NWL3QVteLyEjxt1jPa
	 ZMo31ybgQKsJyI7v30soWOIU8wNlwL141rtWL6cUqmEu9Oq1bk8FP/gppxy5JMnvxY
	 SIP0CRtHKBWfg==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 851AA40407;
	Fri,  4 Apr 2025 16:30:12 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Kent Overstreet <kent.overstreet@linux.dev>, Markus Elfring
 <Markus.Elfring@web.de>
Cc: linux-bcachefs@vger.kernel.org, vulab@iscas.ac.cn,
 stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: Add error handling for zlib_deflateInit2()
In-Reply-To: <morzv5ulzvkdpkegs33bwdocnn3hftxviqmw4wkvlh2qnsfagd@trk7lpvqj37k>
References: <xjtejtaya3znotupznz4eywstkjvucxwyo2gf4b6phcwq6a2i5@pqicczp3ty5g>
 <667bcd67-aac4-425c-b100-d25dc86eb6a9@web.de>
 <morzv5ulzvkdpkegs33bwdocnn3hftxviqmw4wkvlh2qnsfagd@trk7lpvqj37k>
Date: Fri, 04 Apr 2025 10:30:11 -0600
Message-ID: <87ldsfga98.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Kent Overstreet <kent.overstreet@linux.dev> writes:

> On Fri, Apr 04, 2025 at 04:20:18PM +0200, Markus Elfring wrote:
>> =E2=80=A6
>> > > Add an error check and return 0 immediately if the initialzation fai=
ls.
>> >
>> > Applied
>>=20
>> Did you try to avoid a typo in such a change description?
>
> Typos add character :)

Actually, that one *took away* a character ...

(couldn't resist)

jon
