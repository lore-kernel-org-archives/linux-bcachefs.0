Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AE332253A
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Aug 2025 13:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523099; cv=none; b=q+5mw5kgRuz8K6TxtOEJ3+9ySjyalr/YxBIaQplzZl3gvx0yAgEJxhr4VMW0GrDKiGlNLC2EESJELiYKEr9pMVFxe4gt0DrrSkUprXGtHlyd1eKurJJbIcHJS+rTNm+lNh2Owuhgt7dTBEQOyN5HESWr5UXmSjZiPug7TfdJ464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523099; c=relaxed/simple;
	bh=WgauoUWQT8jtKVybl1FQjLAo5ru9YepKL7+pAbrIews=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDe1JSnQtzPaz7qRx7vJaYjjdnetnEVQnRsx9aeZky+fJeyzU0ptsWrzicWsZ2yNKyWs9I47q3Hhns8m7r48EI58W/CieQIM2bAPwQaX5A1jXk7u17uvJhEiRg8VtanDN1SEEHOlWoJtGDTr7Ld4BCPKGaoh/lCCtGk45H0oBeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eGvDx6sZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eGvDx6sZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755523095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EI+lwS0pOMLisQZ2H6RwpS7sAotb8pPEp3ZpZSihh10=;
	b=eGvDx6sZkr/+qNlEqy6XTfqrbBdxMzN5bsWBhZd2IWy2VZXom6/JybJ556nMDNSKgLc+PB
	OhJCxpHv0XUgBiTbt0Oe5Lx7oc7XpaMOKj9jv13xNL6WRrqNKnNV02PfFYTdBfxrsR6VK6
	YAM9d/qmGMSzejnC9sgVKn/4JXYqG9w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-5ziVsjinMkKIKVNsaFNpIg-1; Mon, 18 Aug 2025 09:18:14 -0400
X-MC-Unique: 5ziVsjinMkKIKVNsaFNpIg-1
X-Mimecast-MFC-AGG-ID: 5ziVsjinMkKIKVNsaFNpIg_1755523093
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so17379725e9.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Aug 2025 06:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755523093; x=1756127893;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EI+lwS0pOMLisQZ2H6RwpS7sAotb8pPEp3ZpZSihh10=;
        b=VkzzvisAScFJigUjql1fnujdESG2vgQvQioFlYbtCzsSQxtjKomCoorkaTV11b00FD
         Y7qc+A+0Wms53C787sFgt7Mvv7yGhOmYZxYEaOoESdLg3/x6pzGqySRxZF0fcQdwCzgp
         3VEQBOmQJA+XHzt+ClMLLu1hDVdNbDTjdRE5pBBglzfzCX9OoKyizniahTzlOwm7wuNg
         5c9CgYwpDLGJfA4JqgkugBeJhwzehOhcfZkWV+SyFwOu17P7kbGxx+cPaMLJaPd9QL4O
         AFkgrhDH7QJTDlk9crXEtJyR1Wi4WimaU+r4MtwdMiDc0B9moyy1MCFJR8TcL+72A3Fr
         i1wQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Am8k2YGaNdJCucw9M0d5Oo/j0G556zCHKl6bWavBebYaZ3ttv07HWi0rO2YJTOk2kw3fSEXIuDNweHE71g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwB+LMrxIgoDc9U0zx+ffqgO+wxJmklUqThCDwZGpox1xiK3w1i
	xRYnvVKdcFs1gN64CksEJUf+vnTru7aEUgVmBjsfOWkP79XwXCsQZXmhqSzWMi3ie/UQKWv06UY
	o0R+LE+9BBE5yB5h4qiFgZG0lEN5g9hcT7e4xpTxYTQQrNIS9qmwqsRBrsy2bLxzTY801nhHbyU
	ss
X-Gm-Gg: ASbGncu0gLMJobGgXqumFcXNyw4sGJthsSfQ5cf0z7AI0nKCcKEfpd08hHWOIyQg5Qc
	49LlBIDELjDeGQfoXsK8Mx3jaqAVJt0y5MCWOuxLCNmdA5zGuuYSnQBJdqD1C30x3LuqMBHkUw6
	qtRjLbnyF6UU0abA3HlHINUBuXx0Rr2ABWK1XDqXhPfxMzSB7FB4vXsJAabKXQD4Xh1TE0COV1a
	NAHniJCCB3GiOR2quuZRhnHP1Gt1+Bnavb+7VPmBjLOtRDtfIf21GVkzHdD9yi0U7r6cyPsolO7
	maqwfPtaJetZ/9lnhU7/c+XloBltPXtt9hkYhmPoZI9aBE+YOl5o4oTci4Np69XqdQu9CmLqGIK
	ZMqdsBabXJu8bHi1QeLRWaD2nzdLpLOV3oWLZZKZH/raw5GKOmTx2VTILc+fSzhQ+
X-Received: by 2002:a05:600c:4f02:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45a25d5f37dmr66229535e9.25.1755523093073;
        Mon, 18 Aug 2025 06:18:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvCChE+JR/YLl5igJTrgibt6OaLIWASKnwzJNFN0U4+Ia5ln7iG9FJAn8iRzHdw5mUIB0cBw==
X-Received: by 2002:a05:600c:4f02:b0:459:ddad:a3a3 with SMTP id 5b1f17b1804b1-45a25d5f37dmr66229165e9.25.1755523092684;
        Mon, 18 Aug 2025 06:18:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9431sm13351453f8f.40.2025.08.18.06.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 06:18:12 -0700 (PDT)
Message-ID: <092a4ef3-c97c-4a94-b857-a443fb5f8568@redhat.com>
Date: Mon, 18 Aug 2025 15:18:11 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: remove write_cache_pages
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 linux-bcachefs@vger.kernel.org, ntfs3@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20250818061017.1526853-1-hch@lst.de>
 <20250818061017.1526853-4-hch@lst.de>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250818061017.1526853-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.08.25 08:10, Christoph Hellwig wrote:
> No users left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb

