Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8442520C307;
	Fri, 25 Oct 2024 17:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729876663; cv=none; b=ITa41uFjBTgQoIJGn96Ahg6g7OlRT+QALpCBfp7+Oc5fL3e1RVaJcKg8+QaH/oUF0syhpM692gwJR6AoyqIfDMwkABQFt3jaqdXOPx12MqbnE2RV+IxCflDspigH4x593FWGlq2W01ENdvtC8cItPESc0tR1n5/G9+M4ZKalAl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729876663; c=relaxed/simple;
	bh=/W4BjsF2g/3Ab28MPJejII2YfF/O/fiQLV5AiqxsKKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oa7gqEkhanoLlMs/7xn1PHe7iPy+WLuM0w4Uih/08L9A/lgVF2lFl7no8jhCScUMzP8amuc6bSEtaFNW8LeA9g2U6JY/1lQPodeGK8xCkVhbn/WSF17DQ5oOWY4QLggVEKcRy0N2jh99wNE3PK+MEKCdWUgyz14X8c6etkNgxS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ctBy0kAR; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ctBy0kAR"
Date: Fri, 25 Oct 2024 13:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729876659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smq5rVaIUpH5WH5PYqCq4pJlicNQ2hL9c+U9/UsHKoI=;
	b=ctBy0kAR1ez1z5+r2SXy6s01ud4hFuNt6wuVgEZ1iJX5dDirfN6rxVlkJoslyU/NDmf3lH
	66wK8PX+3YX7igBJW5nBHT3bxnJw9cIxgCROc1Dn7I+1+jT3ldXUYmpAxBbtpSRfGAHU3q
	s8kNAvsgGifcp5Wn5EQmVwGHT/zZL5M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: Jeongjun Park <aha310510@gmail.com>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: fix null-ptr-deref in have_stripes()
Message-ID: <bshr5tserk5lqpfs7xpjz6k3hfptcmoky7z2mhq5mrkbux3bh7@gdsyl2pbmlxx>
References: <20241025115618.2908-1-aha310510@gmail.com>
 <n6nisrv3mklka3whfosvhrcevivri76clgijy3ijdxfbzjkuc3@wuogkgi5kf4s>
 <C6638CB8-4DAF-466F-B1F1-34883C693C2E@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C6638CB8-4DAF-466F-B1F1-34883C693C2E@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 01:05:50AM +0800, Alan Huang wrote:
> On Oct 26, 2024, at 00:54, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > On Fri, Oct 25, 2024 at 08:56:18PM +0900, Jeongjun Park wrote:
> >> c->btree_roots_known[i].b can be NULL. In this case, a NULL pointer dereference
> >> occurs, so you need to add code to check the variable.
> >> 
> >> Reported-by: syzbot+b468b9fef56949c3b528@syzkaller.appspotmail.com
> >> Fixes: 7773df19c35f ("bcachefs: metadata version bucket_stripe_sectors")
> >> Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > 
> > This looks identical to the v1? It's already in my testing branch
> 
> This version fix the “Fixes" tag, the original one is:
> 
> "Fixes: ("bcachefs: metadata version bucket_stripe_sectors”)"

thanks
