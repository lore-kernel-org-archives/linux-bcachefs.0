Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B6814F63
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 16:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TA+rZEWj"
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91BD10F
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Nov 2023 08:18:38 -0800 (PST)
Date: Sun, 12 Nov 2023 11:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699805916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/XOuEb1yBsU4bv5EtFaeqFKYIjee85ZjizUm6e5MDfE=;
	b=TA+rZEWjmZiUE3tWA8Ww5QA2lNov4ZsA1gF3a7VpCZFKiMJtzHf9II8YoKFtxtQTObay3N
	NtVFTGmBqfNGe9J301Omzd+wXJHmpW5b8edV2f4+pjRoTiIcXQ1YmRUC3ls7WMpEC4VL+8
	xelfumkiaraowNdAw7gsxMVpjUbxDPA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Finn Behrens <me@kloenk.de>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH TOOLS v2] rust keylocation add none variant and implement
 ValueEnum
Message-ID: <20231112161832.kct66o33szfgalwo@moria.home.lan>
References: <20231112161236.23565-1-me@kloenk.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231112161236.23565-1-me@kloenk.de>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 12, 2023 at 05:12:36PM +0100, Finn Behrens wrote:
> This enables a possible values help in the clap help text.
> 
> Signed-Off-By: Finn Behrens <me@kloenk.de>

Applied
