Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B227C7EE22
	for <linux-bcachefs@archiver.kernel.org>; Wed, 10 May 2023 11:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbjEJL4a convert rfc822-to-8bit (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 10 May 2023 07:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjEJL42 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 10 May 2023 07:56:28 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E1186BC
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 May 2023 04:56:09 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-266-ezRNJOxiNHGRFTp6EEfw5w-1; Wed, 10 May 2023 12:56:07 +0100
X-MC-Unique: ezRNJOxiNHGRFTp6EEfw5w-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 10 May
 2023 12:56:05 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Wed, 10 May 2023 12:56:05 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kent Overstreet' <kent.overstreet@linux.dev>,
        Lorenzo Stoakes <lstoakes@gmail.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 07/32] mm: Bring back vmalloc_exec
Thread-Topic: [PATCH 07/32] mm: Bring back vmalloc_exec
Thread-Index: AQHZgr3DOem8UG0tfU+5LSPSF/vac69TZImw
Date:   Wed, 10 May 2023 11:56:05 +0000
Message-ID: <aa542818337b4157bfdcf262926b9fe3@AcuMS.aculab.com>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
 <20230509165657.1735798-8-kent.overstreet@linux.dev>
 <ZFqxEWqD19eHe353@infradead.org> <ZFq3SdSBJ_LWsOgd@murray>
 <ZFq7JhrhyrMTNfd/@moria.home.lan>
In-Reply-To: <ZFq7JhrhyrMTNfd/@moria.home.lan>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Kent Overstreet
> Sent: 09 May 2023 22:29
...
> The background is that bcachefs generates a per btree node unpack
> function, based on the packed format for that btree node, for unpacking
> keys within that node. The unpack function is only ~50 bytes, and for
> locality we want it to be located with the btree node's other in-memory
> lookup tables so they can be prefetched all at once.

Loading data into the d-cache isn't going to load code into
the i-cache.
Indeed you don't want to be mixing code and data in the same
cache line - because it just wastes space in the cache.

Looks to me like you could have a few different unpack
functions and pick the correct one based on the packed format.
Quite likely the code would be just as fast (if longer)
when you allow for parallel execution on modern cpu.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

