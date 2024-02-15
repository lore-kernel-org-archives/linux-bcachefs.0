Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98236136672
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708017704; cv=none; b=AEyk5GOhz79jF+A2WituKxRsBk61BuFPnKm8tGw5EsVWeJAOTbaHzL/PsobE8LqN8QbFhrBM8GXjs7/jVHynfMlo5iQfy4ys5wHsEKXBLJ7ji7sQ/TEsmOfEWRfaovf6tiQUDWDvqLQoN8VorKiVerG9Znhb8NN/3JjF8ZYUqCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708017704; c=relaxed/simple;
	bh=gJSbuPXoQttV6qZLMdBfECuxYMnxEPB807AwiyZdOEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/YnBSnUAPIhUmFE50rFQRyGcK51EQmLq/9rXmt5TYdS6Vf8WNJ+oE6eANXJufm+xwbAIdU7hZ7bepnUqCN/0PScfTd8DNnorU4ZJplNyDyiMH7Ovv7yjB+5tcjWkzw37RARyJb0jJtpllfetfu5/cqsbSs6O+4GBVGw7GbdCgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TZyNCjxZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TZyNCjxZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708017701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H/cOU3Q/OpRukBIZETLjCoQoPVvliSUiNCXJUSnGcHs=;
	b=TZyNCjxZKpdRf3bdtA4QNsHFZFi3Zz1zXct5L2410ST2f+F96DNIc+zW9G+v7t8mm0tvdI
	bSmWL2r1U2MRa+zpIR4WWIZ1H3DqVPwsGgLbObBRweO0rUhoUE+RyVB4C040mDlvZF53zr
	WhWBpz++ApOS04/a4SEX/F8CBlTem6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-DqpDy_E_Pp-LpYK3mWg5XQ-1; Thu, 15 Feb 2024 12:21:36 -0500
X-MC-Unique: DqpDy_E_Pp-LpYK3mWg5XQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBFC9811E79;
	Thu, 15 Feb 2024 17:21:35 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E41F492BE4;
	Thu, 15 Feb 2024 17:21:35 +0000 (UTC)
Date: Thu, 15 Feb 2024 12:23:12 -0500
From: Brian Foster <bfoster@redhat.com>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev
Subject: Re: [PATCH] bcachefs: omit alignment attribute on big endian struct
 bkey
Message-ID: <Zc5IgMloeK/XkXR+@bfoster>
References: <20240215161957.112262-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215161957.112262-1-tahbertschinger@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Thu, Feb 15, 2024 at 09:19:57AM -0700, Thomas Bertschinger wrote:
> This is needed for building Rust bindings on big endian architectures
> like s390x. Currently this is only done in userspace, but it might
> happen in-kernel in the future. When creating a Rust binding for struct
> bkey, the "packed" attribute is needed to get a type with the correct
> member offsets. However, rustc does not allow types to have both a
> "packed" and "align" attribute. Thus, in order to get a Rust type
> compatible with the C type, on big endian systems we must omit the
> "aligned" attribute in C.
> 
> This does not affect the struct's size or member offsets, only its
> toplevel alignment, which should be an acceptable impact.
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  fs/bcachefs/bcachefs_format.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index 1bb24aa73528..fc12efe8f8cd 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -222,7 +222,11 @@ struct bkey {
>  
>  	__u8		pad[1];
>  #endif
> -} __packed __aligned(8);
> +} __packed

I can't really comment on the Rust context, but could you add a comment
to explain why the ifdef is here? I.e., even something as simple as
"Rust disallows packed and aligned on ..." is useful.

Also out of curiosity, is there some reason these two attributes
together presumably isn't a problem for LE?

Brian

> +#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
> +__aligned(8)
> +#endif
> +;
>  
>  struct bkey_packed {
>  	__u64		_data[0];
> -- 
> 2.43.0
> 

