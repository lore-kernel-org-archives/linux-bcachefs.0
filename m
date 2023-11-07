Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA1B17C3
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Nov 2023 00:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pyyr4jJ5"
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ac])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E914AD79
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Nov 2023 16:43:26 -0800 (PST)
Date: Mon, 6 Nov 2023 19:43:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699317805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C6HnxRoOPPImtylzQDYeZiH0FMhR4x9tENVXHd4saCI=;
	b=Pyyr4jJ5gMNHCJajjVwQncqEuF65FVFmLBbOhW6sOQI9bbomEEQlSpmTDRG1Bqqh0/d0PN
	fD7AaPSCQ9EZ1FzI2aKwws15ibXFiRL/mjpIeGS8+Cc51D5Sb80gfuWkErerJn5lMiL7xs
	7RtZsT+E8yqZAuiAyyWbrW2DMqCEPuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] bcachefs: Use DECLARE_FLEX_ARRAY() helper and fix
 multiple -Warray-bounds warnings
Message-ID: <20231107004321.onldaaepahzapwz5@moria.home.lan>
References: <ZUloNt0HSulJgZNH@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUloNt0HSulJgZNH@work>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 06, 2023 at 04:27:02PM -0600, Gustavo A. R. Silva wrote:
> Transform zero-length array `s` into a proper flexible-array
> member in `struct snapshot_table` via the DECLARE_FLEX_ARRAY()
> helper; and fix tons of the following -Warray-bounds warnings:
> 
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.c:135:70: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> fs/bcachefs/snapshot.h:36:21: warning: array subscript <unknown> is outside array bounds of 'struct snapshot_t[0]' [-Warray-bounds=]
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks, applied
