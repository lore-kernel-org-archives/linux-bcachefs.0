Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B6CCDB465
	for <linux-bcachefs@archiver.kernel.org>; Mon, 16 Oct 2023 22:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbjJPWNn (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjJPWNn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 16 Oct 2023 18:13:43 -0400
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E00110
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Oct 2023 15:13:30 -0700 (PDT)
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
        by cmsmtp with ESMTP
        id sSNYqCoEjQUgRsVq5qhjvH; Mon, 16 Oct 2023 22:13:29 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTPS
        id sVq4qnTsiN05hsVq5qDg6L; Mon, 16 Oct 2023 22:13:29 +0000
X-Authority-Analysis: v=2.4 cv=Vpwwvs6n c=1 sm=1 tr=0 ts=652db589
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=wYkD_t78qR0A:10 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=cm27Pg_UAAAA:8 a=-c74vyQ1mCLTWBcySUcA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aJ1PK8xOvx4yW7JZZyOpcHR2UxudiTCxLhMj/j7umts=; b=UBTkgnG6qeWrEZbBkllwXK4QY5
        s+NDcBjTU45+h8V1PkYi5qzFSWLyLPrOujrttkM7yPtvTTgS2Q+G0DbCALWaBv/ZemjHS820gWUzi
        3naqR1v32X0dnUuO7UklTgmirToPufNDw48Lw7yUD6QS7YuZ5Yc3qFXbR5pUC4LlwZcB2V4xCJUI+
        pt0vNl+ejdgWONK/xJ/EXpJkERrvFwx9MXQF9Z5pbKQ+/eevehcOgm1it3RjhCHDK8lwbQv5Hvqbo
        JRYhoPW11VOHm7rpmShDc2cTj16L1niSTkqf3zYSki6Whok60CpCqWiMUr/fPNqkWQJ83cgaXljVl
        +I7LV3iw==;
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:39060 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.96.1)
        (envelope-from <gustavo@embeddedor.com>)
        id 1qsVq4-003D8a-0o;
        Mon, 16 Oct 2023 17:13:28 -0500
Message-ID: <cc4831d4-e0c7-418f-9fd3-b6c215d2633e@embeddedor.com>
Date:   Mon, 16 Oct 2023 16:13:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] bcachefs: Refactor bkey_i to use a flexible array
To:     Kees Cook <keescook@chromium.org>,
        Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20231016212735.it.314-kees@kernel.org>
Content-Language: en-US
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20231016212735.it.314-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1qsVq4-003D8a-0o
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.7]) [187.162.21.192]:39060
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEp/FfXjABA+rBsTR4z9c+gL6Em+Zud3onnvJJFn8WJk8idbxOIMnppJSghkbmO0tTAMSIArHUGjUE7Z2zmekqMWf/oLF+h4WVtOlIhOxzoH8G3i8pWg
 aDI2QuawReJ1HkhgiakQKUVKkNLZLvYp4FM4qJjOjP5tZB6Ua9JjxkerVNN17SFrsaOlAPjpKpAlhjRDGnAjVx1vDJx9QsGUhC9QyhMheL531kzcx6zR2zFE
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org



On 10/16/23 15:27, Kees Cook wrote:
> The memcpy() in bch2_bkey_append_ptr() is operating on an embedded
> fake flexible array. Instead, make it explicit, and convert the memcpy
> to target the flexible array instead. Fixes the W=1 warning seen for
> -Wstringop-overflow:
> 
>     In file included from include/linux/string.h:254,
>                      from include/linux/bitmap.h:11,
>                      from include/linux/cpumask.h:12,
>                      from include/linux/smp.h:13,
>                      from include/linux/lockdep.h:14,
>                      from include/linux/radix-tree.h:14,
>                      from include/linux/backing-dev-defs.h:6,
>                      from fs/bcachefs/bcachefs.h:182:
>     fs/bcachefs/extents.c: In function 'bch2_bkey_append_ptr':
>     include/linux/fortify-string.h:57:33: warning: writing 8 bytes into a region of size 0 [-Wstringop-overflow=]
>        57 | #define __underlying_memcpy     __builtin_memcpy
>           |                                 ^
>     include/linux/fortify-string.h:648:9: note: in expansion of macro '__underlying_memcpy'
>       648 |         __underlying_##op(p, q, __fortify_size);                        \
>           |         ^~~~~~~~~~~~~
>     include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
>       693 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>           |                          ^~~~~~~~~~~~~~~~~~~~
>     fs/bcachefs/extents.c:235:17: note: in expansion of macro 'memcpy'
>       235 |                 memcpy((void *) &k->v + bkey_val_bytes(&k->k),
>           |                 ^~~~~~
>     fs/bcachefs/bcachefs_format.h:287:33: note: destination object 'v' of size 0
>       287 |                 struct bch_val  v;
>           |                                 ^
> 
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Brian Foster <bfoster@redhat.com>
> Cc: linux-bcachefs@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202309192314.VBsjiIm5-lkp@intel.com/
> Signed-off-by: Kees Cook <keescook@chromium.org>'

Yes. This looks good.

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
> v2 - Change flex array name to "v_bytes" (bfoster)
> v1 - https://lore.kernel.org/r/20231010235609.work.594-kees@kernel.org
> ---
>   fs/bcachefs/bcachefs_format.h | 5 ++++-
>   fs/bcachefs/extents.h         | 2 +-
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
> index f0d130440baa..cb1af3799b59 100644
> --- a/fs/bcachefs/bcachefs_format.h
> +++ b/fs/bcachefs/bcachefs_format.h
> @@ -300,7 +300,10 @@ struct bkey_i {
>   	__u64			_data[0];
>   
>   	struct bkey	k;
> -	struct bch_val	v;
> +	union {
> +		struct bch_val	v;
> +		DECLARE_FLEX_ARRAY(__u8, v_bytes);
> +	};
>   };
>   
>   #define KEY(_inode, _offset, _size)					\
> diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
> index 7ee8d031bb6c..896fcfca4f21 100644
> --- a/fs/bcachefs/extents.h
> +++ b/fs/bcachefs/extents.h
> @@ -642,7 +642,7 @@ static inline void bch2_bkey_append_ptr(struct bkey_i *k, struct bch_extent_ptr
>   
>   		ptr.type = 1 << BCH_EXTENT_ENTRY_ptr;
>   
> -		memcpy((void *) &k->v + bkey_val_bytes(&k->k),
> +		memcpy(&k->v_bytes[bkey_val_bytes(&k->k)],
>   		       &ptr,
>   		       sizeof(ptr));
>   		k->k.u64s++;
