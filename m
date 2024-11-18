Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C382F38B
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731890402; cv=none; b=A/bfhblWQHS6gC4AWemPg/NCmVMAtO8mnAOMGRzEZrERQje9qWDiIdeVLS+o7WdkL4IXxvZmh9x7QKzH2gZjloOV1er7e2vtkfPaKNyycR4/0uV5uU3puFY+61ktcchNkzeSok3HmxS+jb9gG0xfSPBZhGpplEtoz0zbF6U4GUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731890402; c=relaxed/simple;
	bh=4RF8roOPstTpy7twDEtnddURNg3Z9e4HWF5kkzLn7wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B90Q9vsj+KDSdjtRlHqAlt/r1YtV2Pkf1KmIJLGYDrO/l/MJtwsNN0aX5QrKTafwVBsawRzpP+KzMseaI1itSiGN5jYcEhBedYGo8Cg0yiBEdgWqO/XWIkgoPh+/90SlmtCk26XCGxjogJUc3u0R6RnPnbZOdhDjSb8SiplaYTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZsfWDZc/; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZsfWDZc/"
Date: Sun, 17 Nov 2024 19:39:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731890397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wlfDgOeR/Mb2TWDTd1i3WXtlzuMdvzFZ6f33zvNnJ4M=;
	b=ZsfWDZc/J7TL00fbdlwBlvwiRkm8Le4ViwHNG0vyNlMV1iWtRkLn1UDrWv99Icn2NbReDN
	VKFOiK4wkS+U+6cwrZ+ApYOlv8pk0KZoO6/S+HXualedPeVj7DT9kwiFcuDULcP0y+/plC
	MqDGUQb7iRK+MJ1LjThTxODmcV4EhNg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: syzbot <syzbot+62f5ae3a10a9e97accd4@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in
 bch2_btree_node_iter_init (2)
Message-ID: <bazxq46aftvo7bv5st4tkpebntekbi6th42vcsgvguoafl3qvb@d3zygvbnkb6m>
References: <6739af3b.050a0220.87769.0008.GAE@google.com>
 <TNxAApRrZdXR4QxAVnv4G3kjNaa0xFOi94VAboFOlyOtiAY8oIR8evv4ZHrrl2lPngndHbqKBWTpS_N8HlaFq0YfE-amWQBOPks6cXz3B-I=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TNxAApRrZdXR4QxAVnv4G3kjNaa0xFOi94VAboFOlyOtiAY8oIR8evv4ZHrrl2lPngndHbqKBWTpS_N8HlaFq0YfE-amWQBOPks6cXz3B-I=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 17, 2024 at 11:51:39PM +0000, Piotr Zalewski wrote:
> Hi, all
> 
> This seems to be the proper way to fix this?:
> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 89a42ee81e5c..f92a3fb946de 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -324,6 +324,7 @@ static void btree_node_sort(struct bch_fs *c, struct btree *b,
>  	start_time = local_clock();
>  
>  	u64s = bch2_sort_keys(out->keys.start, &sort_iter.iter);
> +	memset((out->keys.start + u64s), 0, bytes - sizeof(struct btree_node) - u64s * sizeof(u64));
>  
>  	out->keys.u64s = cpu_to_le16(u64s);

Did you do any analysis you can share?

It seems like zeroing out the rest of the buffer shouldn't be necessary:
we do that at write time, where it really is necessary, otherwise we
shouldn't be accessing parts of the buffer that don't have valid keys in
them.

varint_decode_fast, used for inodes, does do reads (that aren't used) up
to 7 bytes past the valid data, so it could be needed if we were seeing
kmsan splats there - but this is bkey comparison, so something fishy
seems to be going on.
