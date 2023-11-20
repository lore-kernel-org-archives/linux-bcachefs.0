Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.de header.i=@kloenk.de header.b="WkNJPymr"
Received: from gimli.kloenk.de (gimli.kloenk.de [IPv6:2a01:4f8:c012:b874::])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F11BF
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Nov 2023 00:16:08 -0800 (PST)
From: Finn Behrens <me@kloenk.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kloenk.de; s=mail;
	t=1700468166; bh=YxBAxJpTM9hm9zkhohSrjfVH1v+oK/+AmOc5LwtUVoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkNJPymrwknMIBXyYR7bEm1/n8ER0gxDD2dYUJVBPZlq34oOaQVQuj7mm3NotDLhF
	 U/x/nGNHx1IaUiNmtzCOhdgbyDQEgSgh8lIQ+gjqy44y9a1SsnH+00wL5s4A2q0+YE
	 oUZ6IYqzRuMqLLgUJ/hLVYFqVnCshqbwRvQRPVHU=
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Finn Behrens <me@kloenk.de>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATH TOOLS] nix: add bcachefs-fuse package
Date: Mon, 20 Nov 2023 09:16:04 +0100
Message-ID: <862316D3-1894-4BCD-8397-4FCA522AABE5@kloenk.de>
In-Reply-To: <20231119232000.rlvnbt254y2hl32l@moria.home.lan>
References: <20231119211314.301361-1-me@kloenk.de>
 <20231119232000.rlvnbt254y2hl32l@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 20 Nov 2023, at 0:20, Kent Overstreet wrote:

> On Sun, Nov 19, 2023 at 10:13:14PM +0100, Finn Behrens wrote:
>> Add a fuseSupport argument and bcachefs-fuse as flake output with fuse=
 enabled.
>>
>> Signed-off-by: Finn Behrens <me@kloenk.de>
>
> We can't do this just yet, not until the fuse support is getting more
> attention; it's been frequently failing to build lately.

This just adds a second output, the default is still building without fus=
e, but with this you can easily let nix build with fuse support.
As there is no sort of nix CI as far as I=E2=80=99m aware, this should al=
so not block anything.

Second option would be to mark with fuse as broken, but keep this. Then y=
ou have to opt into potentially broken packages when using the
fuse support via a environment variable while calling nix.

>
> There have been people getting interested in that code though, so -
> soon, perhaps?
