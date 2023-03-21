Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5469C6FD1D
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCUNjQ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbjCUNjP (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503DB49C1
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679405908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5srGbwZPrCg3TBxtgR+hIJyYYromyxLjlNlnqJLzggw=;
        b=FyFFjkikomtbfti+uA/qEF9aKf8rVNW6haFgvx2hZPsn03HGwcL4XJRFzLJUHqY8fZQGyL
        ONMH0YE1B8YAOjX3UrRDUe3TQTBG03TMROpLpGEFSezX4h8w7fhEIgCkYaMkE2J7uqKDMO
        tEmvKkB3YMT9Lqs7H6BabpbnEZoFmA4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-VddTN3aDOeGuAQQVAjkcBg-1; Tue, 21 Mar 2023 09:38:27 -0400
X-MC-Unique: VddTN3aDOeGuAQQVAjkcBg-1
Received: by mail-qt1-f198.google.com with SMTP id u22-20020a05622a011600b003dfd61e8594so4306828qtw.15
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679405906;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5srGbwZPrCg3TBxtgR+hIJyYYromyxLjlNlnqJLzggw=;
        b=HL0bNQd6rFAp3RISW0OVbAKajh9VqS495CVijy3PvbEqXn2MJPTZEYMLr6SIxLUMer
         olGp73HG/HtiVaQNL6d8Oc6VP66DauF6dNnjhhE89YxebiRTislnXQW4OJGNzjEU9zrq
         O96Y3ZnL/YjOeFxrRgNTwVMRO9YGW74rf5jsbfFf2IYIkaBRkwsoEapzlowyeV0r/gpW
         ikaLSJ9+qiS49ddrkjMfIwl1UqTXVRBqfiJHKx7KBa4OBFUEI/aV+BXMWfW79UVuNQ6y
         LIgVr0c79LE76EnCOYrHmEpzedkQ0p75hmN99JaEDj86u7BPtQw6e5Rvx4u8gSAHiaOD
         SGJw==
X-Gm-Message-State: AO0yUKV3QWExK7M9HB1UPuhmXM+NG94P2/t5tCy+MH9xVUPUDI6nUWAG
        ElD58wJcUBpMVacJHpnXlo8dYK6RMDGhiP7Fo+FizbuPSmH/qu4h5XXMlLjobdGfHfyPG7bPY87
        vqw8AQ8bJ3JyNNz3zVQf2S92qYJ+MYfb3SWKxbF8kq7XMCwoCeeqYBiPzly5QEiwDVM5iWPpy/w
        VNmq1CfEV7fw==
X-Received: by 2002:a05:622a:1191:b0:3dc:7fcc:31c7 with SMTP id m17-20020a05622a119100b003dc7fcc31c7mr4307202qtk.2.1679405906400;
        Tue, 21 Mar 2023 06:38:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set/op1yu+enLbnJxNFX84hjXHL+Dz2Rz0jbUbA/r8LsUJW03OlL54LLY48SycT8NeXNdDO7ekw==
X-Received: by 2002:a05:622a:1191:b0:3dc:7fcc:31c7 with SMTP id m17-20020a05622a119100b003dc7fcc31c7mr4307169qtk.2.1679405906041;
        Tue, 21 Mar 2023 06:38:26 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id x26-20020ac86b5a000000b003bfa2c512e6sm8312159qts.20.2023.03.21.06.38.25
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 06:38:25 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:40:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/5] bcachefs: more aggressive fast path write buffer key
 flushing
Message-ID: <ZBmzunR3GYZw8Tkl@bfoster>
References: <20230321132014.1438249-1-bfoster@redhat.com>
 <20230321132014.1438249-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321132014.1438249-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Tue, Mar 21, 2023 at 09:20:10AM -0400, Brian Foster wrote:
> The btree write buffer flush code is prone to causing journal
> deadlock due to inefficient use and release of reservation space.
> Reservation is not pre-reserved for write buffered keys (as is done
> for key cache keys, for example), because the write buffer flush
> side uses a fast path that attempts insertion without need for any
> reservation at all.
> 
> The write buffer flush attempts to deal with this by inserting keys
> using the BTREE_INSERT_JOURNAL_RECLAIM flag to return an error on
> journal reservations that require blocking. Upon first error, it
> falls back to a slow path that inserts in journal order and supports
> moving the associated journal pin forward.
> 
> The problem is that under pathological conditions (i.e. smaller log,
> larger write buffer and journal reservation pressure), we've seen
> instances where the fast path fails fairly quickly without having
> completed many insertions, and then the slow path is unable to push
> the journal pin forward enough to free up the space it needs to
> completely flush the buffer. This problem is occasionally reproduced
> by fstest generic/333.
> 
> To avoid this problem, update the fast path algorithm to skip key
> inserts that fail due to inability to acquire needed journal
> reservation without immediately breaking out of the loop. Instead,
> insert as many keys as possible, zap the sequence numbers to mark
> them as processed, and then fall back to the slow path to process
> the remaining set in journal order. This reduces the amount of
> journal reservation that might be required to flush the entire
> buffer and increases the odds that the slow path is able to move the
> journal pin forward and free up space as keys are processed.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/bcachefs/btree_write_buffer.c | 41 ++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
> index 80f4b9839bc2..32f20e631de0 100644
> --- a/fs/bcachefs/btree_write_buffer.c
> +++ b/fs/bcachefs/btree_write_buffer.c
...
> @@ -198,23 +203,19 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
>  slowpath:
>  	trace_write_buffer_flush_slowpath(trans, i - keys, nr);
>  
> -	dst = keys;
> -	for (; i < keys + nr; i++) {
> -		if (i + 1 < keys + nr &&
> -		    i[0].btree == i[1].btree &&
> -		    bpos_eq(i[0].k.k.p, i[1].k.k.p))
> -			continue;
> -
> -		*dst = *i;
> -		dst++;
> -	}
> -	nr = dst - keys;
> -

This one leaves an unused var warning. I've fixed it locally but will
wait for any further comments before reposting.

Brian

> +	/*
> +	 * Now sort the rest by journal seq and bump the journal pin as we go.
> +	 * The slowpath zapped the seq of keys that were successfully flushed so
> +	 * we can skip those here.
> +	 */
>  	sort(keys, nr, sizeof(keys[0]),
>  	     btree_write_buffered_journal_cmp,
>  	     NULL);
>  
>  	for (i = keys; i < keys + nr; i++) {
> +		if (!i->journal_seq)
> +			continue;
> +
>  		if (i->journal_seq > pin.seq) {
>  			struct journal_entry_pin pin2;
>  
> -- 
> 2.39.2
> 

