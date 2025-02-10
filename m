Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048672580C8
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739204710; cv=none; b=FkfDsF030mQnxHKARIoKszADOVxnxvezqqFthWJ2eAyZUoZRY5A43mKOEm8eHfShylPOShoicJGpt4oayPuSbxWMf/aMOWxXu28hRNpE4BK+XuA11Xv1qyDJu5/r4lLlaBFe/cDJ5za75xuWBh7dyGin+tCX1bVRH1CeD4/qHkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739204710; c=relaxed/simple;
	bh=pR1MluGCtMnCQFWJ1u3aFDoCVYfBvwP1dYtiEz2OOQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nrt2PZ4hGIbLsulioTqcglLP23XeIItXzIfK1484eMtcQ6vyxcpqQasfYIz/zWF1SzSvgVdJ11CHwSSVGCWcT1zQR0eLvWhHKn/LhzBZKXMTCbCj5mNFKvkId8iCrM9T50hbd+lgFD9sYuoTVs1yxOeCciYm73Hp9bpVANibJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hzApzRod; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hzApzRod"
Date: Mon, 10 Feb 2025 11:25:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739204705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hRsIJKJZLVFRdMdbSyPapCpu34Mg27+xcDrdHKDGrYU=;
	b=hzApzRodYn52ihIE/BgL4gQ++gwu3nWUjN8mJEYKBkypMqebsLfP/amwZTNIWu7BxOtM3m
	H2xzitKmr9u5irSsa75ZSfIOgQSO6R7cZz59veM6FUOfQqytDIDXsxjev4BKNI+ZxFwr0u
	/f3Sa3IhGSpYnR6RSJW9+biZHwKhBno=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use uncompressed_size as the operand
Message-ID: <sspfmyovbhs3d5a66cs7eau3xxkiebtvjhff3kw7iauzwhnn2y@e2f4wklauoiw>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210030422.711912-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Feb 10, 2025 at 11:04:21AM +0800, Alan Huang wrote:
> Since we don't merge compressed extents, uncompressed_size should be
> equal to compressed_size, use uncompressed_size to clarify the intention.

compressed_size actually describes the intention better here, it refers
to size ondisk, and we're checking if the extents are contiguous on disk

> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/extents.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
> index 05d5f71a7ca9..eeea23d09b9a 100644
> --- a/fs/bcachefs/extents.c
> +++ b/fs/bcachefs/extents.c
> @@ -326,7 +326,7 @@ bool bch2_extent_merge(struct bch_fs *c, struct bkey_s l, struct bkey_s_c r)
>  			    !bch2_checksum_mergeable(lp.crc.csum_type))
>  				return false;
>  
> -			if (lp.crc.offset + lp.crc.live_size != lp.crc.compressed_size ||
> +			if (lp.crc.offset + lp.crc.live_size != lp.crc.uncompressed_size ||
>  			    rp.crc.offset)
>  				return false;
>  
> -- 
> 2.47.0
> 
