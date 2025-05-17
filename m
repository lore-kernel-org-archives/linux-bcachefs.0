Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44A5155335
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 12:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747484668; cv=none; b=olJklTplRGCd3Xh80NHqX0dJodV+XuayxyzuAVV2DNsGqw/q2/l4sFJu1IanlKv2VxqPhbCs5xqxAA+4C9R6rDZKEEaFOuG/uxANEV++56uw5NAuYbFko6KKfbN4nuCcLlVjjSQd+ggUm+/t6WOs2w/TlW5IcjQBhL4kvCHQEkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747484668; c=relaxed/simple;
	bh=hRFc6fr5YQ7ve6lvCl7ypX8t6sV7Gy7hnOk8z/PaEEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iptmw0dUTCvM9DsbYwqEGFQUHn6opULYY/vpv4TvM9u4MBT/7ovhMumP7yCLG+X+TTL5C0st6sDkrfnjgyebuXrQQyHH2Bq0u+seT+lDwy8juqzM+j4nAK45vE8HD8shWSEr6kLjUt0TiWbB3wwEsAirhmUGqNg0Dih21BSJk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com; spf=pass smtp.mailfrom=pavinjoseph.com; dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b=AbvzkkDM; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b="AbvzkkDM"
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 935CA2146F
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 12:18:57 +0000 (UTC)
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.154])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 937EB20063
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 12:18:47 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay4.mymailcheap.com (Postfix) with ESMTPS id B6B2420310;
	Sat, 17 May 2025 12:18:39 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 96C6640084;
	Sat, 17 May 2025 12:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pavinjoseph.com;
	s=default; t=1747484317;
	bh=hRFc6fr5YQ7ve6lvCl7ypX8t6sV7Gy7hnOk8z/PaEEM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=AbvzkkDMu3kuknJv0KkCqVQFRJIz1BVWe5dKgOlHt19XtHv2GQ6r/GtWjx87CScg6
	 0lvnFjzUWWvtTY1E54t81m+cKADv/q7XiBZepCkMZL85qSGznFzqXyNT50R1BSl8HA
	 4eY//kZc1kigkUCqzgFSkNxizF0emU1VXvqiUuVc=
Received: from [10.66.66.8] (unknown [139.59.64.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 000584016D;
	Sat, 17 May 2025 12:18:35 +0000 (UTC)
Message-ID: <dc1fd78f-57fc-4659-a27f-0eb2904668ab@pavinjoseph.com>
Date: Sat, 17 May 2025 17:48:33 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Status of rebalance and scrub support
To: Martin Steigerwald <martin@lichtvoll.de>, linux-bcachefs@vger.kernel.org,
 =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
 <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
 <5890559.DvuYhMxLoT@lichtvoll.de>
Content-Language: en-US
From: Pavin Joseph <me@pavinjoseph.com>
In-Reply-To: <5890559.DvuYhMxLoT@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 96C6640084
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [-0.10 / 10.00];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ONE(0.00)[1];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3]
X-Rspamd-Action: no action

On 5/17/25 4:11 PM, Martin Steigerwald wrote:
> So seems since 6.15 there is scrub support :)

That's wonderful news!
Could you check if rebalance is also working in 6.15?

Thanks,
Pavin.
