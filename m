Received: from mail.tnxip.de (mail.tnxip.de [49.12.77.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8E1E4BE
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 12:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.77.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484504; cv=none; b=ByiQWo1+eg4GP42KeLw8myk9L3mZxZZ3BSCI4ClGZVB9z5NVYOL0qSJxtvKR/H20KSqHnA5pUHFBLKyZljG2k1fq5f037QnMPpJUV/M3k+OqIonRWFmMyAjcn6OQH/rdaBdoI3YWSXCvZXeJcKlY7mEweuZbxI4OMpRiKgUokLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484504; c=relaxed/simple;
	bh=9NHiQsqAtdy3EJIgm6IaQ+euuzG7il7Hjh3AxvdKMHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qWZEd+Pqhx231B8QzYDnBi6x6bYnaMY5if7ghS+Qg3QowF0RmfSMMwHn4wW6i2GoxoCcryUYU9QoG+LhvJ3C/AXq9f/jD/x50qmQnmArQCJEA2hqzw3mm5l7EOUydq+82ogb6pOMGpFKeQD+FG5EL2SEf0o8BCvImyUnj72UooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de; spf=pass smtp.mailfrom=tnxip.de; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=ot6znRZ2; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=88bu2blu; dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=k+uO4b/k; dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b=Dh+FPnND; arc=none smtp.client-ip=49.12.77.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tnxip.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tnxip.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="ot6znRZ2";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="88bu2blu";
	dkim=pass (1024-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="k+uO4b/k";
	dkim=permerror (0-bit key) header.d=tnxip.de header.i=@tnxip.de header.b="Dh+FPnND"
Received: from gw.tnxip.de (unknown [IPv6:fdc7:1cc3:ec03:1:a4c6:597:2a14:e443])
	by mail.tnxip.de (Postfix) with ESMTPS id 19DFB208AB;
	Sat, 17 May 2025 14:21:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-vps;
	t=1747484495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NHiQsqAtdy3EJIgm6IaQ+euuzG7il7Hjh3AxvdKMHg=;
	b=ot6znRZ2EmajfEDNhwkbP3qjohSw0vayAYPMtvLPFrHQaWnja9aFYK6ajN/XPsSPz7AKRe
	CTbaZiIaalF+X3DM3iZlHJnKLI+9BOzCYzNWGq3ymqL5rLZLiawkAEoX6iUh026/lCdoK2
	XCNHim7K0BNuFbpvjdFpdd3db8oVl80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-vps-ed; t=1747484495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NHiQsqAtdy3EJIgm6IaQ+euuzG7il7Hjh3AxvdKMHg=;
	b=88bu2blusiE/WiDqW5TKqX48gb5yaOp1HnRWEJrnMYIpyvp+jallyzIqLwCwVvIyApyP8C
	uy/qhBERelg49XCA==
Received: from [IPV6:2a04:4540:8c09:8c00:7f69:c40:c544:7ff3] (unknown [IPv6:2a04:4540:8c09:8c00:7f69:c40:c544:7ff3])
	by gw.tnxip.de (Postfix) with ESMTPSA id C8AE31800000000015181;
	Sat, 17 May 2025 14:21:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tnxip.de; s=mail-gw;
	t=1747484494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NHiQsqAtdy3EJIgm6IaQ+euuzG7il7Hjh3AxvdKMHg=;
	b=k+uO4b/kjgOxLT/He/oJxayYqhUSuMpZfVCIn+HPNqSuaU0JNRchHvTq/7KEg4vX1qVOP5
	rirBKK6BDfU/YshX/AQMRspqpYA/r2JhyGqbYv0Oqk2chwxDJpbCddYndtuECHBbEiq24n
	wSa/PXbu/wpwNrimOoBk7E8/7C42OvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=tnxip.de;
	s=mail-gw-ed; t=1747484494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NHiQsqAtdy3EJIgm6IaQ+euuzG7il7Hjh3AxvdKMHg=;
	b=Dh+FPnNDGPN5NByMkAAFrR5/59DjXW2kAavT921zEN1U9xtyzMg1WCKOl8ZfhIJ3m8l8mv
	SdkulC5qknuB0gCQ==
Message-ID: <21f52b7b-d351-4292-a20c-309729795dd9@tnxip.de>
Date: Sat, 17 May 2025 14:21:34 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Linux)
Subject: Re: Status of rebalance and scrub support
To: Pavin Joseph <me@pavinjoseph.com>,
 Martin Steigerwald <martin@lichtvoll.de>, linux-bcachefs@vger.kernel.org
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
 <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
 <5890559.DvuYhMxLoT@lichtvoll.de>
 <dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
In-Reply-To: <dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/05/2025 14:18, Pavin Joseph wrote:
> On 5/17/25 4:11 PM, Martin Steigerwald wrote:
>> So seems since 6.15 there is scrub support :)
>
> That's wonderful news!
> Could you check if rebalance is also working in 6.15?
>
> Thanks,
> Pavin.

If by "rebalance" you mean equalize the amount of data between drives
(like btrfs): No, it can't do that at the moment. There is a thing
called rebalance on bcachefs, but it does something different (I think
it moves data between tiers).

/Malte

